#include "appwindow.h"
#include <QStorageInfo>
#include <QVariant>
#include <QQuickItem>
#include "dwmapi.h"
#include "Windows.h"
#include "windowsx.h"
#include "ShlObj.h"
#include <QThread>
#include <limits>


HWND AppWindow::m_hwnd = 0;

AppWindow::AppWindow(QQmlEngine& engine):m_mainComp(&engine, QUrl(QStringLiteral("qrc:/MWindow.qml")))
{
    connect(&engine, &QQmlEngine::quit, QApplication::instance(), &QApplication::quit, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("AppWindow", this);
    engine.addImageProvider(m_imageProvId, new PixmapProvider);
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());
    m_hwnd = (HWND)pWindow->winId();
    m_leftFSModel = qobject_cast<ProxyFileSystemModel*>(pWindow->findChild<QObject*>(m_leftFSModelName));
    m_rightFSModel = qobject_cast<ProxyFileSystemModel*>(pWindow->findChild<QObject*>(m_rightFSModelName));

    HWND hwnd = reinterpret_cast<HWND>(pWindow->winId());
    //change the window's style and shadows
    BOOL dwmTest = FALSE;
    if (DwmIsCompositionEnabled(&dwmTest) == static_cast<HRESULT>(0L) && dwmTest){
        SetWindowLongPtrA(hwnd, GWL_STYLE, static_cast<LONG>(WS_POPUP | WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX));
        MARGINS extendMtx{ 1,1,1,1 };
        DwmExtendFrameIntoClientArea(hwnd, &extendMtx);
    }
    else
    {
       SetWindowLongPtrA(hwnd, GWL_STYLE, static_cast<LONG>(WS_POPUP | WS_THICKFRAME | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX));
    }
    //redraw the frame
    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE);
    ShowWindow(hwnd, SW_SHOW);
}


QUrl AppWindow::requestImageSource(QVariant icon){
    PixmapProvider* prov = static_cast<PixmapProvider*>(m_mainComp.engine()->imageProvider(m_imageProvId));
    return prov->getImageSource(m_imageProvId, icon);
}

void AppWindow::updateOtherHeader(QString callerViewObjName){
    QString otherViewObj;
    if (callerViewObjName == m_leftViewName) otherViewObj = m_rightViewName;
    else if (callerViewObjName == m_rightViewName) otherViewObj = m_leftViewName;
    else return;
    QObject* otherView = pWindow->findChild<QObject*>(otherViewObj);
    QObject* repeater = otherView->findChild<QObject*>("repeaterObj");
    QJSValue var = pWindow->property("columnWidths").value<QJSValue>();
    for (int i = 0; i < var.property("length").toInt(); i++){
        QQuickItem* ret;
        QMetaObject::invokeMethod(repeater,"itemAt", Qt::DirectConnection, Q_RETURN_ARG(QQuickItem*, ret), Q_ARG(int, i));
        ret->setProperty("width", var.property(i).toVariant());
    }
}

QString AppWindow::getRootPathOfModel(QString name){
    if (name == m_leftFSModelName) return m_leftFSModel->rootPath();
    else if (name == m_rightFSModelName) return m_rightFSModel->rootPath();
    else return QString();
}

QString AppWindow::storageInfo(QString path){
    QString result;
    QStorageInfo info(path);
    result = "[%1] %2 - %3 bytes available";
    return result.arg(QString(info.fileSystemType())).arg(QString(info.displayName())).arg(QString::number(info.bytesAvailable()));
}

bool AppWindow::isDir(QString filePath){
    QFileInfo path(filePath);
    return path.isDir();
}

// WINDOWS API-SPECIFIC FUNCTIONALITY STARTS HERE

bool openShellContextMenuForObject(CComHeapPtr<ITEMIDLIST>, int xPos, int yPos, void * parentWindow);
void AppWindow::openContextMenu(QString path){
    m_bgThread = QThread::create([&]{
        HRESULT result = SHParseDisplayName(QDir::toNativeSeparators(path).toStdWString().c_str(), 0, &(this->m_iidlist.id), 0, 0);
        if (!SUCCEEDED(result) || !(this->m_iidlist.id)) this->m_iidlist.m_contextMenuParseStatus = false;
        else this->m_iidlist.m_contextMenuParseStatus = true;
    });

    connect(m_bgThread,&QThread::finished,this,[&]{
        if (this->m_iidlist.m_contextMenuParseStatus){
            QPoint pos(QCursor::pos());
            openShellContextMenuForObject(this->m_iidlist.id, pos.x(), pos.y(), (HWND)pWindow->winId());
            this->m_iidlist.id.Free();
        }
        m_bgThread->quit();
    });

    m_bgThread->start();
}


bool openShellContextMenuForObject(CComHeapPtr<ITEMIDLIST> id, int xPos, int yPos, void * parentWindow){
    IShellFolder * iFolder = 0;

    ITEMIDLIST* idChild = 0;
    HRESULT result = SHBindToParent(id, IID_IShellFolder, (void**)&iFolder, (LPCITEMIDLIST*)&idChild);
    if (!SUCCEEDED(result) || !iFolder)
        return false;

    IContextMenu * iMenu = 0;
    result = iFolder->GetUIObjectOf((HWND)parentWindow, 1, (const ITEMIDLIST **)&idChild, IID_IContextMenu, 0, (void**)&iMenu);
    if (!SUCCEEDED(result) || !iMenu)
        return false;

    HMENU hMenu = CreatePopupMenu();
    if (!hMenu)
        return false;
    if (SUCCEEDED(iMenu->QueryContextMenu(hMenu, 0, 1, std::numeric_limits<UINT>::max(), CMF_NORMAL | CMF_CANRENAME)))
    {
        // perhaps try to get the value of the largest iCmd value stored in QueryContextMenu's HRESULT return value
        // and call IContextMenu::GetCommandString for each command value to store their string values separately
        // in a QML popup menu instead
        int iCmd = TrackPopupMenuEx(hMenu, TPM_RETURNCMD, xPos, yPos, (HWND)parentWindow, NULL);
        if (iCmd > 0)
        {
            CMINVOKECOMMANDINFOEX info = { 0 };
            info.cbSize = sizeof(info);
            info.fMask = CMIC_MASK_UNICODE;
            info.hwnd = (HWND)parentWindow;
            info.lpVerb  = MAKEINTRESOURCEA(iCmd - 1);
            info.lpVerbW = MAKEINTRESOURCEW(iCmd - 1);
            info.nShow = SW_SHOWNORMAL;
            iMenu->InvokeCommand((LPCMINVOKECOMMANDINFO)&info);
        }
    }
    DestroyMenu(hMenu);
    iFolder->Release();
    iMenu->Release();
    return true;
}

void tryFitMonitor(HWND hwnd, RECT& wndRect) {
        WINDOWPLACEMENT placement;
        bool wndSuccess = GetWindowPlacement(hwnd, &placement);
        HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
        MONITORINFO monInfo{};
        monInfo.cbSize = sizeof(monInfo);
        if (wndSuccess && placement.showCmd == SW_MAXIMIZE && monitor && GetMonitorInfoW(monitor, &monInfo)) {
            wndRect = monInfo.rcWork;
        }
}

LRESULT hit_test(MSG* event){
    RECT wnd;
    if (GetWindowRect(reinterpret_cast<HWND>(event->hwnd), &wnd)) {
        auto xPos = GET_X_LPARAM(event->lParam);
        auto yPos = GET_Y_LPARAM(event->lParam);
        POINT wndBorder;
        wndBorder.x = GetSystemMetrics(SM_CXPADDEDBORDER) + GetSystemMetrics(SM_CXFRAME);
        wndBorder.y = GetSystemMetrics(SM_CXPADDEDBORDER) + GetSystemMetrics(SM_CYFRAME);
    short lMask = 1 * (xPos <  (wnd.left   + wndBorder.x)),
          rMask = 2 * (xPos >= (wnd.right  - wndBorder.x)),
          tMask = 4 * (yPos <  (wnd.top    + wndBorder.y)),
          bMask = 8 * (yPos >= (wnd.bottom - wndBorder.y)),
          captionMask = 16 * (xPos >= (wnd.left   + wndBorder.x)  &&  xPos < (wnd.right - wndBorder.x - 74) &&
                              yPos >= (wnd.top    + wndBorder.y)  &&  yPos < (wnd.top + 30));
    short test = lMask | rMask | tMask | bMask | captionMask;

    if (test & lMask) return HTLEFT;
    else if (test & rMask) return HTRIGHT;
    else if (test & tMask) return HTTOP;
    else if (test & bMask) return HTBOTTOM;
    else if (test & (tMask | lMask)) return HTTOPLEFT;
    else if (test & (tMask | rMask)) return HTTOPRIGHT;
    else if (test & (bMask | lMask)) return HTBOTTOMLEFT;
    else if (test & (bMask | rMask)) return HTBOTTOMRIGHT;
    else if (test & captionMask) return HTCAPTION;
    else return HTNOWHERE;

    } else return HTNOWHERE;
}

bool NativeFilter::nativeEventFilter(const QByteArray &eventType, void *message, long *result){
    if (eventType == "windows_generic_MSG"){
        MSG *event = static_cast<MSG*>(message);
        switch(event->message){
            case WM_NCCALCSIZE:{
                if (event->wParam == TRUE){
                  auto& params = *reinterpret_cast<NCCALCSIZE_PARAMS*>(event->lParam);
                  tryFitMonitor(event->hwnd, params.rgrc[0]);
                  *result = WVR_VALIDRECTS;
                  return true;
                }
                break;
            }
            case WM_NCHITTEST:{
                long value = hit_test(event);
                if (value != HTNOWHERE){
                    *result = value;
                    return true;
                }
                break;
            }
        }
    }
    return false;
}
