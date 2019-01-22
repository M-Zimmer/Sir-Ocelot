#include "appwindow.h"
#include <QScreen>
#include <QVariant>
#include "dwmapi.h"
#include "Windows.h"
#include "windowsx.h"

AppWindow::AppWindow(QQmlEngine& engine):m_mainComp(&engine, QUrl(QStringLiteral("qrc:/MWindow.qml"))),
                                         m_leftFSModel(new ProxyFileSystemModel(this)),
                                         m_rightFSModel(new ProxyFileSystemModel(this)), m_watcher(new QFileSystemWatcher(this)),
                                         m_columnWidths(QVector<int>{200, 100, 125, 150}){
    connect(&engine, &QQmlEngine::quit, QApplication::instance(), &QApplication::quit, Qt::QueuedConnection);
    connect(m_watcher,SIGNAL(directoryChanged(QString)),SLOT(refresh(QString)));
    connect(m_watcher,SIGNAL(fileChanged(QString)),SLOT(refresh(QString)));
    engine.rootContext()->setContextProperty("AppWindow", this);
    engine.addImageProvider(m_imageProvId, new PixmapProvider);
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());
    m_leftFSModel= qobject_cast<ProxyFileSystemModel*>(pWindow->findChild<QObject*>("leftFSModel"));
    QFileSystemModel* fs = m_leftFSModel->fs();
    connect(fs,SIGNAL(directoryLoaded(QString)),SLOT(onDirectoryLoaded(QString)));
    fs->setRootPath(QDir::rootPath());
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

void AppWindow::refresh(QString){
    QFileSystemModel* fs = m_leftFSModel->fs();
    if (!m_watcher->directories().isEmpty()) m_watcher->removePaths(m_watcher->directories());
    if (!m_watcher->files().isEmpty()) m_watcher->removePaths(m_watcher->files());
    QString curPath = fs->rootPath();
    fs->setRootPath("");
    fs->setRootPath(curPath);
}

void AppWindow::onDirectoryLoaded(const QString path){
    QObject* viewObj = pWindow->findChild<QObject*>("leftViewObj");
    QVariant model = viewObj->property("model");
    viewObj->setProperty("model", "undefined");
    QFileSystemModel* fs = m_leftFSModel->fs();
    fs->sort(0);
    viewObj->setProperty("model", model);
}

QUrl AppWindow::requestImageSource(QVariant icon){
    PixmapProvider* prov = static_cast<PixmapProvider*>(m_mainComp.engine()->imageProvider(m_imageProvId));
    return prov->getImageSource(m_imageProvId, icon);
}

QString AppWindow::fileData(QString filePath, int column){
    QFileSystemModel* fs = m_leftFSModel->fs();
    QVariant result = fs->data(fs->index(filePath,column));
    m_watcher->addPath(filePath);
    return result.toString();
}

QVariant AppWindow::headerData(int index){
    QFileSystemModel* fs = m_leftFSModel->fs();
    return fs->headerData(index, Qt::Horizontal);
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
