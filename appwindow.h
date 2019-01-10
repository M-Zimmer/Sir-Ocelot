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
#include <QAbstractNativeEventFilter>

class NativeFilter: public QAbstractNativeEventFilter{

public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *) override;
};

class AppWindow: public QObject{
    Q_OBJECT
    public:
    AppWindow(QQmlEngine&);
    private:
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        QPoint m_lastCurPos;
};
#endif // APPWINDOW_H
