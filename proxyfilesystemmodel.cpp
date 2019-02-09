#include "proxyfilesystemmodel.h"
#include "appwindow.h"
#include "ShlObj.h"


ProxyFileSystemModel::ProxyFileSystemModel(QObject*): m_watcher(new QFileSystemWatcher(this)){
    setSourceModel(new QFileSystemModel(this));
    connect(fs(),SIGNAL(directoryLoaded(QString)),SLOT(onDirectoryLoaded(QString)));
    connect(m_watcher,SIGNAL(directoryChanged(QString)),SLOT(refresh(QString)));
    connect(m_watcher,SIGNAL(fileChanged(QString)),SLOT(refresh(QString)));
    connect(fs(),SIGNAL(rootPathChanged(QString)),this,SIGNAL(rootPathChanged(QString)));
    fs()->setRootPath(QDir::rootPath());
    fs()->setReadOnly(false);
    fs()->setFilter(QDir::AllDirs | QDir::AllEntries | QDir::System | QDir::Hidden | QDir::NoDotAndDotDot);
}

QModelIndex ProxyFileSystemModel::index(int row, int column, const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->QFileSystemModel::index(fs()->rootPath()));
    return QIdentityProxyModel::index(row, column, proxyRootIndex);
}

int ProxyFileSystemModel::columnCount(const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->QFileSystemModel::index(fs()->rootPath()));
    return QIdentityProxyModel::columnCount(proxyRootIndex);
}

int ProxyFileSystemModel::rowCount(const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->QFileSystemModel::index(fs()->rootPath()));
    return QIdentityProxyModel::rowCount(proxyRootIndex);
}


void ProxyFileSystemModel::refresh(QString s){
    if (!m_watcher->directories().isEmpty()) m_watcher->removePaths(m_watcher->directories());
    if (!m_watcher->files().isEmpty()) m_watcher->removePaths(m_watcher->files());
    QString curPath = fs()->rootPath();
    fs()->setRootPath("");
    fs()->setRootPath(curPath);
}

void ProxyFileSystemModel::onDirectoryLoaded(const QString path){
    QVariant model = property("model");
    setProperty("model", "undefined");
    fs()->sort(0);
    setProperty("model", model);
}

QString ProxyFileSystemModel::fileData(QString filePath, int column){
    QVariant result;
    result = fs()->data(fs()->QFileSystemModel::index(filePath,column));
    m_watcher->addPath(filePath);
    return result.toString();
}

QVariant ProxyFileSystemModel::headerData(int index, Qt::Orientation orient, int role) const{
    return QIdentityProxyModel::headerData(index, orient, role);
}

void ProxyFileSystemModel::cdUp(){
    QDir dir(rootPath());
    if (dir.cdUp()) setRootPath(dir.path());
}

void ProxyFileSystemModel::fileDelete(QVariant selection){
    QString pathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      if (!val[i].isValid()) continue;
      QString modelFilePath = data(index(i,0),QFileSystemModel::FilePathRole).toString();
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
    delete paths;
}

void ProxyFileSystemModel::fileRename(QModelIndex index, QString newName){
    if (!index.isValid()) return;
    QDir dir = data(index,QFileSystemModel::FilePathRole).toString();
    dir.cdUp();
    dir.rename(data(index,QFileSystemModel::FilePathRole).toString(), newName);
}

void ProxyFileSystemModel::fileCopy(QVariant selection, QString destinationPath){
    QString sourcePathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      if (!val[i].isValid()) continue;
      QString modelFilePath = data(index(i,0),QFileSystemModel::FilePathRole).toString();
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
    delete srcPaths;
    delete destPath;
}

void ProxyFileSystemModel::fileMove(QVariant selection, QString destinationPath){
    QString sourcePathSequence = "";
    QVariantList val = selection.value<QVariantList>();
    for (int i = 0; i < val.size(); ++i){
      if (!val[i].isValid()) continue;
      QString modelFilePath = data(index(i,0),QFileSystemModel::FilePathRole).toString();
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
    delete srcPaths;
    delete destPath;
}
