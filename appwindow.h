// Copyright 2018-2019 Max Mazur
/*
    This file is part of Sir Ocelot File Manager.

    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sir Ocelot File Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef APPWINDOW_H
#define APPWINDOW_H
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QQuickWindow>
#include <QAbstractNativeEventFilter>
#include <QAbstractItemModel>
#include <QDir>
#include "pixmapprovider.h"
#include "newfilemaker.h"
#include "atlbase.h"
#include <QProcess>
#include <QStandardPaths>

class NativeFilter: public QAbstractNativeEventFilter{

public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *) override;
};

class AppWindow: public QObject{
    Q_OBJECT
    public:
    // make an enum in the future to contain values for the column types of the views' headers
    AppWindow(QQmlEngine&, QObject* parent = nullptr);
    Q_INVOKABLE QUrl requestImageSource(QString);

    Q_INVOKABLE void addToFavorites(QString name, QVariant tabUrls);
    Q_INVOKABLE void addToRecentlyClosed(QString name, QVariant tabUrls);
    Q_INVOKABLE QVariant favoritePanels();
    Q_INVOKABLE QVariant recentlyClosedPanels();

    Q_INVOKABLE QString fileType(QString);
    Q_INVOKABLE void fileDelete(QVariant selection);
    Q_INVOKABLE void fileCopy(QVariant selection, QString destination);
    Q_INVOKABLE void fileRename(QString oldName, QString newName);
    Q_INVOKABLE void fileMove(QVariant selection, QString destination);
    Q_INVOKABLE QObject* getModel(QString name);
    Q_INVOKABLE QVariant getDrives();
    Q_INVOKABLE QVariant getRootFolder(QUrl);
    Q_INVOKABLE QVariant getNewFileExt();
    Q_INVOKABLE void makeNewFile(QString destPath, int index, QString newName = "", QString linkname = "");

    Q_INVOKABLE QVariant startSearch(QString pattern, QString startLocation, bool mode, QString depth);

    Q_INVOKABLE void updateOtherHeader(QString viewObjName);

    Q_INVOKABLE QUrl urlFromPath(QString input, QString workingDir = QDir::currentPath());
    Q_INVOKABLE QString pathFromUrl(QUrl url);
    Q_INVOKABLE QString storageInfo(QString path);
    Q_INVOKABLE void openContextMenu(QVariant paths, QString commandOverride = "");
    Q_INVOKABLE void runApp(QString command){ QProcess::startDetached(command);}
    Q_INVOKABLE QUrl getStandardPathUrl(int pathId);

    static HWND hwnd() {return m_hwnd;}
    private:
        void queryShellNewEntries();
        bool findShellNew(HKEY rootKey, HKEY& result);
        void search(QString pattern, QDir curDir, int maxDepth, int curDepth, QVariantList& out);
        QQmlComponent m_mainComp;
        QQuickWindow* pWindow;
        static HWND m_hwnd;
        QAbstractItemModel* m_leftFSModel = 0;
        QAbstractItemModel* m_rightFSModel = 0;
        const QString m_imageProvId = "PixmapProvider";
        const QString m_leftFSModelName = "leftFSModel";
        const QString m_rightFSModelName = "rightFSModel";
        const QString m_leftViewName = "leftViewObj";
        const QString m_rightViewName = "rightViewObj";
        QThread* m_bgThread = 0;
        QVector<NewFileMaker> newFileOptions;
        struct _parsedITEMIDLIST{
            CComHeapPtr<ITEMIDLIST> id;
            bool m_contextMenuParseStatus = false;
        } *m_iidlist = nullptr;
};
#endif // APPWINDOW_H
