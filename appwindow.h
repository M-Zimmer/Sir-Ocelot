#ifndef APPWINDOW_H
#define APPWINDOW_H
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQuickWindow>
#include <QAbstractNativeEventFilter>
#include "proxyfilesystemmodel.h"
#include "pixmapprovider.h"
#include "atlbase.h"

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
    Q_INVOKABLE void updateOtherHeader(QString viewObjName);
    Q_INVOKABLE QString getRootPathOfModel(QString name);
    Q_INVOKABLE QString storageInfo(QString path);
    Q_INVOKABLE void openContextMenu(QString);
    Q_INVOKABLE bool isDir(QString);
    static HWND hwnd() {return m_hwnd;}
    private:
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        static HWND m_hwnd;
        ProxyFileSystemModel* m_leftFSModel = 0;
        ProxyFileSystemModel* m_rightFSModel = 0;
        const QString m_imageProvId = "PixmapProvider";
        const QString m_leftFSModelName = "leftFSModel";
        const QString m_rightFSModelName = "rightFSModel";
        const QString m_leftViewName = "leftViewObj";
        const QString m_rightViewName = "rightViewObj";
        QThread* m_bgThread = 0;
        struct _parsedITEMIDLIST{
            CComHeapPtr<ITEMIDLIST> id;
            bool m_contextMenuParseStatus = false;
        } m_iidlist;
};
#endif // APPWINDOW_H
