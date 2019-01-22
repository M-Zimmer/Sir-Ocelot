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
    // make an enum in the future which contains values for the column types of the views' headers
    AppWindow(QQmlEngine&);
    Q_INVOKABLE QUrl requestImageSource(QVariant);
    Q_INVOKABLE int columnCount(){return m_columnCount;}
    Q_INVOKABLE int columnWidth(int column){ return m_columnWidths[column];}
    Q_INVOKABLE QString fileData(QString filePath, int column);
    Q_INVOKABLE QVariant headerData(int column);
    private slots:
        void refresh(QString);
        void onDirectoryLoaded(const QString);
    private:
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        ProxyFileSystemModel* m_leftFSModel = 0;
        ProxyFileSystemModel* m_rightFSModel = 0;
        QFileSystemWatcher* m_watcher;
        const QString m_imageProvId = "PixmapProvider";
        int m_columnCount = 4;
        QVector<int> m_columnWidths;
};
#endif // APPWINDOW_H
