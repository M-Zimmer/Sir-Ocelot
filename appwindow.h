#ifndef APPWINDOW_H
#define APPWINDOW_H
#include <QObject>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QCursor>
#include <QPoint>
#include <QQuickWindow>

class AppWindow: public QObject{
    Q_OBJECT
    public:
    AppWindow();
    Q_INVOKABLE void handleDragEvent();
    Q_INVOKABLE void handlePressedEvent();
    Q_INVOKABLE void handleMaximizeEvent();
    private:
        QQmlEngine m_engine;
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        QPoint m_lastCurPos;
};
#endif // APPWINDOW_H
