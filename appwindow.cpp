#include "appwindow.h"
#include <QScreen>
#include <QVariant>
#include "dwmapi.h"
#include "Windows.h"
#include "windowsx.h"


AppWindow::AppWindow(QQmlEngine& engine):m_mainComp(&engine, QUrl(QStringLiteral("qrc:/MWindow.qml"))),
                                         m_leftFSModel(new ProxyFileSystemModel(this)),
                                         m_rightFSModel(new ProxyFileSystemModel(this)){
    QObject::connect(&engine, &QQmlEngine::quit, QApplication::instance(), &QApplication::quit, Qt::QueuedConnection);
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());
    m_leftFSModel= qobject_cast<ProxyFileSystemModel*>(pWindow->findChild<QObject*>("leftFSModel"));
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(m_leftFSModel->sourceModel());
    fs->setRootPath(QDir::currentPath());
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
