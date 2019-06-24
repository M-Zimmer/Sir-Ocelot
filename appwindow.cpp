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

#include "appwindow.h"
#include <QStorageInfo>
#include <QVariant>
#include <QQuickItem>
#include "dwmapi.h"
#include "Windows.h"
#include "windowsx.h"
#include "ShlObj.h"
#include <QThread>
#include <limits>
#include <QDateTime>
#include <QFileIconProvider>
#include <QRegularExpression>
#include "session.h"
#include "atlhost.h"


HWND AppWindow::m_hwnd = 0;

AppWindow::AppWindow(QQmlEngine& engine, QObject* parent):QObject(parent),m_mainComp(&engine, QUrl(QStringLiteral("qrc:/MWindow.qml")))
{
    connect(&engine, &QQmlEngine::quit, QGuiApplication::instance(), &QGuiApplication::quit, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("AppWindow", this);
    engine.addImageProvider(m_imageProvId, new PixmapProvider);
    newFileOptions.push_back(NewFileMaker(NewFileMaker::Type::NFM_FOLDER));
    newFileOptions.push_back(NewFileMaker(NewFileMaker::Type::NFM_LINK));
    queryShellNewEntries();
    pWindow = qobject_cast<QQuickWindow*>(m_mainComp.create());
    m_hwnd = (HWND)pWindow->winId();
    m_leftFSModel = qobject_cast<QAbstractItemModel*>(pWindow->findChild<QObject*>(m_leftFSModelName));
    m_rightFSModel = qobject_cast<QAbstractItemModel*>(pWindow->findChild<QObject*>(m_rightFSModelName));
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


QUrl AppWindow::requestImageSource(QString path){
    QFileIconProvider iconProv;
    QIcon icon = iconProv.icon(path);
    PixmapProvider* prov = static_cast<PixmapProvider*>(m_mainComp.engine()->imageProvider(m_imageProvId));
    return prov->getImageSource(m_imageProvId, icon);
}

void AppWindow::addToFavorites(QString name, QVariant tabUrls){
    Session* session = qobject_cast<Session*>(parent());
    session->saveToFavorites(name, tabUrls);
}

void AppWindow::addToRecentlyClosed(QString name, QVariant tabUrls){
    Session* session = qobject_cast<Session*>(parent());
    session->saveToRecentlyClosed(name, tabUrls);
}

QVariant AppWindow::favoritePanels(){
    Session* session = qobject_cast<Session*>(parent());
    return session->favoritePanels();
}
QVariant AppWindow::recentlyClosedPanels(){
    Session* session = qobject_cast<Session*>(parent());
    return session->recentlyClosedPanels();
}

QString AppWindow::fileType(QString path){
    QFileIconProvider iconProv;
    QString type = iconProv.type(path);
    return type;
}


QVariant AppWindow::startSearch(QString pattern, QString startLocation, bool mode, QString depthStr){
    if (!mode) pattern = QRegularExpression::wildcardToRegularExpression(pattern);
    int depth = depthStr.toInt();
    QVariantList result;
    // look through current dir for pattern matches, add the necessary data into new list entry when a match is found
    // if the current depth level is equal to the max depth level or no folders are found, stop
    // else enter the inner directory and repeat the process above
    QDir startDir(startLocation);
    startDir.setFilter(startDir.filter() | QDir::Hidden | QDir::System | QDir::NoDotAndDotDot);
    search(pattern, startDir, depth, 0, result);
    //
    return result;
}

void AppWindow::search(QString pattern, QDir curDir, int maxDepth, int curDepth, QVariantList& out){
    auto list = curDir.entryInfoList();
    QRegularExpression reg(pattern, QRegularExpression::DotMatchesEverythingOption);
    QList<QDir> dirList;
    for (auto it = list.cbegin(); it != list.cend(); ++it){
        QVariantList newEntry;
        bool isFolder;
        if (isFolder = it->isDir()){
            QDir newDir(it->filePath());
            newDir.setFilter(newDir.filter() | QDir::Hidden | QDir::System | QDir::NoDotAndDotDot);
            dirList.push_back(newDir);
        }
        auto match = reg.match(it->fileName());
        if (match.hasMatch()){
            newEntry.push_back(it->fileName());
            newEntry.push_back(it->filePath());
            newEntry.push_back(it->size());
            newEntry.push_back(it->lastModified());
            newEntry.push_back(isFolder);
            out.push_back(newEntry);
        }
    }
    if (curDepth == maxDepth) return;
    else if (dirList.isEmpty()) return;
    else{
        for (auto it = dirList.cbegin(); it != dirList.cend(); ++it){
            search(pattern, *it, maxDepth, curDepth + 1, out);
        }
    }
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

QObject* AppWindow::getModel(QString name){
    if (name == m_leftFSModelName) return m_leftFSModel;
    else if (name == m_rightFSModelName) return m_rightFSModel;
    else return nullptr;
}

QVariant AppWindow::getDrives(){
    auto drives = QDir::drives();
    QVariantList list;
    for (auto it = drives.cbegin(); it != drives.cend(); ++it)
      list.append(it->filePath());
    return QVariant(list);
}

QVariant AppWindow::getRootFolder(QUrl path){
    QString pathStr = path.path();
    QFileInfoList drives = QDir::drives();
    for (auto it = drives.cbegin(); it != drives.cend(); ++it){
        QString driveStr = it->absolutePath();
        if (pathStr.contains(driveStr, Qt::CaseInsensitive)) {
            return QUrl::fromUserInput(driveStr);
        }
    }
    return QDir::rootPath();
}

QVariant AppWindow::getNewFileExt(){
    QVariantList list;
    // store the display names of each NewFileMaker object from AppWindow's QVector<NewFileMaker> member in list
    for (int i = 0; i < newFileOptions.size(); i++){
        QString str;
        if (!newFileOptions[i].displayName().length())
            str = "(" + newFileOptions[i].extension() + ")";
        else if (!newFileOptions[i].extension().length())
            str = newFileOptions[i].displayName();
        else str = newFileOptions[i].displayName() + " (" + newFileOptions[i].extension() + ")";
        list.push_back(str);
    }
    return QVariant(list);
}

void AppWindow::makeNewFile(QString path, int i, QString newName, QString linkName){
    newFileOptions[i].createNewObj(path, newName, linkName);
}

QUrl AppWindow::urlFromPath(QString input , QString workingDir){
    return QUrl::fromUserInput(input, workingDir);
}

QString AppWindow::pathFromUrl(QUrl url){
    return url.toDisplayString(QUrl::PreferLocalFile);
}

QString AppWindow::storageInfo(QString path){
    QString result = "[%1] %2 - %3 bytes available";
    QStorageInfo info(path);
    return result.arg(QString(info.fileSystemType())).arg(QString(info.displayName())).arg(QString::number(info.bytesAvailable()));
}

QUrl AppWindow::getStandardPathUrl(int pathId){
    QStandardPaths::StandardLocation path = (QStandardPaths::StandardLocation)pathId;
    return QUrl::fromLocalFile(QStandardPaths::writableLocation(path));
}

// WINDOWS API-SPECIFIC FUNCTIONALITY STARTS HERE

void AppWindow::queryShellNewEntries(){
    HKEY hKey;
    TCHAR    achKey[512];   // buffer for subkey name
    DWORD    cbName = 512;                  // size of name string
    DWORD    cSubKeys=0;               // number of subkeys
    DWORD    cbMaxSubKey;              // longest subkey size
    DWORD    cValues;              // number of values for key
    DWORD    cType;
    DWORD    cbMaxValue;
    DWORD    cbMaxValueData;       // longest value data
    LPWSTR achValue;
    LPBYTE achValueData;
    DWORD cchValueData;
    DWORD cchValue;
    int count = 0;
    bool shellNewIsValid = false;
    if( RegOpenKeyExW( HKEY_CLASSES_ROOT, NULL, 0, KEY_READ, &hKey) == ERROR_SUCCESS){
        if (RegQueryInfoKeyW(hKey, NULL, NULL, NULL, &cSubKeys, &cbMaxSubKey, NULL, NULL, NULL, NULL, NULL, NULL) == ERROR_SUCCESS){
            for (unsigned int i = 0; i < cSubKeys; i++){
                shellNewIsValid = false;
                cbName = cbMaxSubKey+1;
                LSTATUS status = RegEnumKeyExW(hKey, i, achKey, &cbName, NULL, NULL, NULL, NULL);
                if (status == ERROR_SUCCESS && QString::fromWCharArray(achKey).startsWith('.')){
                    // recursively search for a ShellNew key
                    if (QString::fromWCharArray(achKey) == ".lnk") continue;
                    HKEY extKey, shellNewKey;
                    if (RegOpenKeyExW(hKey, achKey, 0, KEY_READ, &extKey) == ERROR_SUCCESS)
                    {
                        if (findShellNew(extKey, shellNewKey)){
                            QString extStr = QString::fromWCharArray(achKey);
                            count++;

                            if (RegQueryInfoKeyW(shellNewKey, NULL, NULL, NULL, NULL, NULL, NULL, &cValues, &cbMaxValue, &cbMaxValueData, NULL, NULL) == ERROR_SUCCESS){
                                for (unsigned int j = 0; j < cValues; j++){
                                    achValue = new WCHAR[cbMaxValue+1];
                                    achValueData = new BYTE[cbMaxValueData];
                                    cchValueData = cbMaxValueData;
                                    cchValue = cbMaxValue+1;
                                    if(RegEnumValueW(shellNewKey, j, achValue, &cchValue, NULL, &cType, achValueData, &cchValueData) == ERROR_SUCCESS){
                                        if (QString::fromWCharArray(achValue).toUpper() == "COMMAND" && (cType == REG_SZ || cType == REG_EXPAND_SZ)){
                                            LPWSTR data = (LPWSTR)achValueData;
                                            data[cchValueData/sizeof(WCHAR)-1] = '\0';
                                            if (cType == REG_EXPAND_SZ){
                                                LPWSTR expandedData = new WCHAR[32767];
                                                if(ExpandEnvironmentStringsW(data, expandedData, 32767)){
                                                    newFileOptions.push_back(NewFileMaker(extStr, NewFileMaker::Type::NFM_COMMAND, QString::fromWCharArray(expandedData)));
                                                }
                                                delete[] expandedData;
                                            }else{
                                                shellNewIsValid = true;
                                                newFileOptions.push_back(NewFileMaker(extStr, NewFileMaker::Type::NFM_COMMAND, QString::fromWCharArray(data)));
                                            }
                                        }else if (QString::fromWCharArray(achValue).toUpper() == "NULLFILE"){
                                            newFileOptions.push_back(NewFileMaker(extStr));
                                            shellNewIsValid = true;
                                        }else if (QString::fromWCharArray(achValue).toUpper() == "FILENAME" && (cType == REG_SZ)){
                                            LPWSTR data = (LPWSTR)achValueData;
                                            data[cchValueData/sizeof(WCHAR)-1] = '\0';
                                            newFileOptions.push_back(NewFileMaker(extStr, NewFileMaker::Type::NFM_FILENAME, QString::fromWCharArray(data)));
                                            shellNewIsValid = true;
                                        }else if (QString::fromWCharArray(achValue).toUpper() == "DATA" && (cType == REG_BINARY)){
                                            QByteArray data = QByteArray::fromRawData((const char*)achValueData, cchValueData);
                                            char c = data[0];
                                            data[0] = '0';
                                            data[0] = c;
                                            newFileOptions.push_back(NewFileMaker(extStr, NewFileMaker::Type::NFM_DATA, data));
                                            shellNewIsValid = true;
                                        }
                                    }
                                    delete[] achValueData;
                                    delete[] achValue;
                                    if (shellNewIsValid) break;
                                }
                            }
                            if (shellNewIsValid && RegQueryInfoKeyW(extKey, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &cbMaxValueData, NULL, NULL) == ERROR_SUCCESS){
                                achValueData = new BYTE[cbMaxValueData];
                                if (RegQueryValueExW(extKey, NULL, NULL, &cType, achValueData, &cbMaxValueData) == ERROR_SUCCESS && cType == REG_SZ){
                                    LPWSTR str = (LPWSTR)achValueData;
                                    str[cbMaxValueData/sizeof(WCHAR)-1] = '\0';
                                    for (unsigned int k = i+1; k < cSubKeys; k++){
                                      cbName = cbMaxSubKey+1;
                                      if (RegEnumKeyExW(hKey, k, achKey, &cbName, NULL, NULL, NULL, NULL) == ERROR_SUCCESS){
                                        if (QString::fromWCharArray(achKey) == QString::fromWCharArray(str)){
                                          HKEY nameKey;
                                          if (RegOpenKeyEx(hKey, achKey, 0, KEY_READ, &nameKey) == ERROR_SUCCESS){
                                            DWORD displayNameSize;
                                            if (RegQueryInfoKeyW(nameKey, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &displayNameSize, NULL, NULL) == ERROR_SUCCESS){
                                              LPBYTE displayNameData = new BYTE[displayNameSize];
                                                if (RegQueryValueExW(nameKey, NULL, NULL, NULL, displayNameData, &displayNameSize) == ERROR_SUCCESS){
                                                  LPWSTR data = (LPWSTR)displayNameData;
                                                  data[displayNameSize/sizeof(WCHAR)-1] = '\0';
                                                  newFileOptions[newFileOptions.size()-1].setDisplayName(QString::fromWCharArray(data));
                                                }
                                              delete[] displayNameData;
                                            }
                                            RegCloseKey(nameKey);
                                          }
                                          break;
                                        }
                                      }
                                    }
                                }
                                delete[] achValueData;
                            }
                            // if found, look for values with the names "Command", "NullFile", "FileName", "Data" in this order
                            // if found, read the (Default) value of this file extension key and search for the key with this name
                            // read the (Default) value of that key and use it as the display name of this file type's New option
                            RegCloseKey(shellNewKey);
                        }
                        RegCloseKey(extKey);
                    }
                }
            }
        }
    }
}

bool AppWindow::findShellNew(HKEY rootKey, HKEY& result){
    DWORD    cSubKeys=0;
    DWORD    cbMaxSubKey;
    TCHAR    achKey[512];
    DWORD    cbName = 512;
    if (RegQueryInfoKeyW(rootKey, NULL, NULL, NULL, &cSubKeys, &cbMaxSubKey, NULL, NULL, NULL, NULL, NULL, NULL) == ERROR_SUCCESS){
        for (unsigned int i = 0; i < cSubKeys; i++){
            cbName = cbMaxSubKey+1;
            if (RegEnumKeyExW(rootKey, i, achKey, &cbName, NULL, NULL, NULL, NULL) == ERROR_SUCCESS){
              if (QString::fromWCharArray(achKey).toUpper() != "SHELLNEW") // call findShellNew where rootKey is achKey's HKEY and result is result
              {
                HKEY key;
                if (RegOpenKeyExW(rootKey, achKey, 0, KEY_READ, &key) == ERROR_SUCCESS){
                  if (findShellNew(key, result)) { RegCloseKey(key); return true;}
                  RegCloseKey(key);
                }
              }else{
                if (RegOpenKeyExW(rootKey, achKey, 0, KEY_READ, &result) == ERROR_SUCCESS) return true;
              }
            }
        }
    }
    return false;
}

void AppWindow::fileDelete(QVariant selection){
    QString pathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      QString modelFilePath = val[i].value<QString>();
      pathSequence += QDir::toNativeSeparators(modelFilePath);
      pathSequence += '\0';
    }
    pathSequence += '\0';
    PWSTR paths = new WCHAR[pathSequence.length()];
    pathSequence.toWCharArray(paths);
    SHFILEOPSTRUCTW fOp;
    fOp.hwnd = AppWindow::hwnd();
    fOp.wFunc = FO_DELETE;
    fOp.pFrom = paths;
    fOp.fFlags = FOF_ALLOWUNDO | FOF_WANTNUKEWARNING;
    SHFileOperationW(&fOp);
    delete[] paths;
}

void AppWindow::fileRename(QString path, QString newName){
    QFileInfo info(path);
    QDir dir(path);
    dir.cdUp();
    dir.rename(info.fileName(), newName);
}

void AppWindow::fileCopy(QVariant selection, QString destinationPath){
    QString sourcePathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      QString modelFilePath = val[i].value<QString>();
      sourcePathSequence += QDir::toNativeSeparators(modelFilePath);
      sourcePathSequence += '\0';
    }
    sourcePathSequence += '\0';
    destinationPath = QDir::toNativeSeparators(destinationPath);
    destinationPath += '\0';
    destinationPath += '\0';
    PWSTR srcPaths = new WCHAR[sourcePathSequence.length()];
    PWSTR destPath = new WCHAR[destinationPath.length()];
    sourcePathSequence.toWCharArray(srcPaths);
    destinationPath.toWCharArray(destPath);
    SHFILEOPSTRUCTW fOp;
    fOp.hwnd = AppWindow::hwnd();
    fOp.wFunc = FO_COPY;
    fOp.pFrom = srcPaths;
    fOp.pTo = destPath;
    fOp.fFlags = FOF_ALLOWUNDO;
    SHFileOperationW(&fOp);
    delete[] srcPaths;
    delete[] destPath;
}

void AppWindow::fileMove(QVariant selection, QString destinationPath){
    QString sourcePathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      QString modelFilePath = val[i].value<QString>();
      sourcePathSequence += QDir::toNativeSeparators(modelFilePath);
      sourcePathSequence += '\0';
    }
    sourcePathSequence += '\0';
    destinationPath = QDir::toNativeSeparators(destinationPath);
    destinationPath += '\0';
    destinationPath += '\0';
    PWSTR srcPaths = new WCHAR[sourcePathSequence.length()];
    PWSTR destPath = new WCHAR[destinationPath.length()];
    sourcePathSequence.toWCharArray(srcPaths);
    destinationPath.toWCharArray(destPath);
    SHFILEOPSTRUCTW fOp;
    fOp.hwnd = AppWindow::hwnd();
    fOp.wFunc = FO_MOVE;
    fOp.pFrom = srcPaths;
    fOp.pTo = destPath;
    fOp.fFlags = FOF_ALLOWUNDO;
    SHFileOperationW(&fOp);
    delete[] srcPaths;
    delete[] destPath;
}

bool openShellContextMenuForObject(CComHeapPtr<ITEMIDLIST>*, UINT sz, int xPos, int yPos, void * parentWindow, QString commandOverride = ""); //CComHeapPtr<ITEMIDLIST>


void AppWindow::openContextMenu(QVariant paths, QString commandOverride){
    QVariantList val = paths.value<QVariantList>();
    this->m_iidlist = new AppWindow::_parsedITEMIDLIST[val.size()];
    m_bgThread = QThread::create([&, val]{
        for (int i = 0; i < val.size(); ++i){
            QString path = val[i].value<QString>();
            HRESULT result = SHParseDisplayName(QDir::toNativeSeparators(path).toStdWString().c_str(), 0, &(this->m_iidlist[i].id), 0, 0);
            if (!SUCCEEDED(result) || !(this->m_iidlist[i].id)) this->m_iidlist[i].m_contextMenuParseStatus = false;
            else this->m_iidlist[i].m_contextMenuParseStatus = true;
        }
    });

    connect(m_bgThread,&QThread::finished,this,[&, val, commandOverride]{
            CComHeapPtr<ITEMIDLIST>* iidPtr = new CComHeapPtr<ITEMIDLIST>[val.size()];
            for (int i = 0; i < val.size(); ++i){
                if (this->m_iidlist[i].m_contextMenuParseStatus){
                    iidPtr[i] = this->m_iidlist[i].id;
                } else {
                    for (int i = 0; i < val.size(); ++i) this->m_iidlist[i].id.Free();
                    delete[] iidPtr;
                    delete[] this->m_iidlist;
                    m_bgThread->quit();
                    return;
                }
            }
            QPoint pos(QCursor::pos());
            openShellContextMenuForObject(iidPtr, val.length(), pos.x(), pos.y(), (HWND)pWindow->winId(), commandOverride);
            for (int i = 0; i < val.size(); ++i) this->m_iidlist[i].id.Free();
            delete[] iidPtr;
            delete[] this->m_iidlist;
            m_bgThread->quit();
    });
    m_bgThread->start();
}


bool openShellContextMenuForObject(CComHeapPtr<ITEMIDLIST>* id, UINT sz, int xPos, int yPos, void * parentWindow, QString commandOverride){
    IShellFolder * iFolder = 0;
    ITEMIDLIST** idChild = new ITEMIDLIST*[sz];
    for (unsigned int i = 0; i < sz; ++i){
        HRESULT result = SHBindToParent(id[i], IID_IShellFolder, (void**)&iFolder, (LPCITEMIDLIST*)&idChild[i]);
        if (!SUCCEEDED(result) || !iFolder)
            return false;
    }
    IContextMenu * iMenu = 0;
    HRESULT result = iFolder->GetUIObjectOf((HWND)parentWindow, sz, (const ITEMIDLIST **)idChild, IID_IContextMenu, 0, (void**)&iMenu);
    //HRESULT result = iFolder->CreateViewObject((HWND)parentWindow, IID_IContextMenu, (void**)&iMenu);
    if (!SUCCEEDED(result) || !iMenu){
        return false;
    }
    HMENU hMenu = CreatePopupMenu();
    if (!hMenu)
        return false;
    if (SUCCEEDED(iMenu->QueryContextMenu(hMenu, 0, 1, std::numeric_limits<UINT>::max(), CMF_NORMAL | CMF_CANRENAME)))
    {
        // perhaps try to get the value of the largest iCmd value stored in QueryContextMenu's HRESULT return value
        // and call IContextMenu::GetCommandString for each command value to store their string values separately
        // in a QML popup menu instead
        int iCmd;
        if (commandOverride.isEmpty()) {
            iCmd = TrackPopupMenuEx(hMenu, TPM_RETURNCMD, xPos, yPos, (HWND)parentWindow, NULL);
        }else iCmd = 1;
        if (iCmd > 0)
        {
            char* override = new char[commandOverride.length() + 1];
            wchar_t* overrideW = new wchar_t[commandOverride.length() + 1];
            qstrcpy(override, commandOverride.toLatin1().constData());
            int sizeW = commandOverride.toStdWString().copy(overrideW, commandOverride.toStdWString().size());
            overrideW[sizeW] = '\0';
            CMINVOKECOMMANDINFOEX info = { 0 };
            info.cbSize = sizeof(info);
            info.fMask = CMIC_MASK_UNICODE;
            info.hwnd = (HWND)parentWindow;
            if (commandOverride.isEmpty())
            {
                info.lpVerb  = MAKEINTRESOURCEA(iCmd - 1);
                info.lpVerbW = MAKEINTRESOURCEW(iCmd - 1);
            }else {
               info.lpVerb = override;
               info.lpVerbW = overrideW;
            }
            info.nShow = SW_SHOWNORMAL;
            iMenu->InvokeCommand((LPCMINVOKECOMMANDINFO)&info);
            delete override;
            delete overrideW;
        }
    }
    DestroyMenu(hMenu);
    hMenu = NULL;
    iFolder->Release();
    iMenu->Release();
    delete[] idChild;
    return true;
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
