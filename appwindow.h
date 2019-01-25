#ifndef APPWINDOW_H
#define APPWINDOW_H
#include <QObject>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQuickWindow>
#include <QFileSystemModel>
#include <QFileSystemWatcher>
#include <QAbstractNativeEventFilter>
#include "proxyfilesystemmodel.h"
#include "pixmapprovider.h"

class NativeFilter: public QAbstractNativeEventFilter{

public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *) override;
};

class AppWindow: public QObject{
    Q_OBJECT

    public:
    // make an enum in the future to contain values for the column types of the views' headers
    AppWindow(QQmlEngine&);
    Q_INVOKABLE QUrl requestImageSource(QVariant);
    Q_INVOKABLE int columnCount(){return m_columnCount;}
    Q_INVOKABLE int columnWidth(int column){ return m_columnWidths[column];}
    Q_INVOKABLE void updateOtherHeader(QString viewObjName);
    Q_INVOKABLE QString storageInfo(QString path);
    private:
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        ProxyFileSystemModel* m_leftFSModel = 0;
        ProxyFileSystemModel* m_rightFSModel = 0;
        const QString m_imageProvId = "PixmapProvider";
        const QString m_leftFSModelName = "leftFSModel";
        const QString m_rightFSModelName = "rightFSModel";
        const QString m_leftViewName = "leftViewObj";
        const QString m_rightViewName = "rightViewObj";
        int m_columnCount = 4;
        QVector<int> m_columnWidths;
};
#endif // APPWINDOW_H
