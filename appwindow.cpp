#include "appwindow.h"
#include <QScreen>

AppWindow::AppWindow():m_mainComp(&m_engine, QUrl(QStringLiteral("qrc:/MWindow.qml"))){
    QObject::connect(&m_engine, &QQmlEngine::quit, &QGuiApplication::quit);
    m_engine.rootContext()->setContextProperty("AppWindow", this);
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());
    //HWND hwnd = (HWND)pWindow->winId();
    //pWindow->setMask(QRegion(0,0,pWindow->width(),pWindow->height()));
}

void AppWindow::handleDragEvent(){
    pWindow->setX(pWindow->x() + (QCursor::pos().x() - m_lastCurPos.x()));
    pWindow->setY(pWindow->y() + (QCursor::pos().y() - m_lastCurPos.y()));
    m_lastCurPos = QCursor::pos();
}

void AppWindow::handlePressedEvent(){
    m_lastCurPos = QCursor::pos();
}

void AppWindow::handleMaximizeEvent(){
    /* if (window.visibility != Window.Maximized) window.showMaximized();
            else window.showNormal(); */
    if (pWindow->visibility() != QWindow::Maximized){
        pWindow->showMaximized();
    }
    else{
        pWindow->showNormal();
    }
}
