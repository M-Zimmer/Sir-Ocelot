#include "appwindow.h"
#include <QStorageInfo>
#include <QScreen>
#include <QVariant>
#include <QQuickItem>
#include "dwmapi.h"
#include "Windows.h"
#include "windowsx.h"

AppWindow::AppWindow(QQmlEngine& engine):m_mainComp(&engine, QUrl(QStringLiteral("qrc:/MWindow.qml"))),
                                         m_columnWidths(QVector<int>{200, 100, 125, 150}){
    connect(&engine, &QQmlEngine::quit, QApplication::instance(), &QApplication::quit, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("AppWindow", this);
    engine.addImageProvider(m_imageProvId, new PixmapProvider);
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());

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

QString AppWindow::storageInfo(QString path){
    QString result;
    QStorageInfo info(path);
    result = "[%1] %2 - %3 bytes available";
    return result.arg(QString(info.fileSystemType())).arg(QString(info.displayName())).arg(QString::number(info.bytesAvailable()));
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
