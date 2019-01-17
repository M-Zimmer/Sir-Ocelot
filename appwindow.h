#ifndef APPWINDOW_H
#define APPWINDOW_H
#include <QObject>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQuickWindow>
#include <QFileSystemModel>
#include <QAbstractNativeEventFilter>
#include "proxyfilesystemmodel.h"

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
        ProxyFileSystemModel* m_leftFSModel = 0;
        ProxyFileSystemModel* m_rightFSModel = 0;
};
#endif // APPWINDOW_H
