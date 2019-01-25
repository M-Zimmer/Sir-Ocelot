#include "proxyfilesystemmodel.h"

ProxyFileSystemModel::ProxyFileSystemModel(QObject*): m_watcher(new QFileSystemWatcher(this)){
    setSourceModel(new QFileSystemModel);
    connect(fs(),SIGNAL(directoryLoaded(QString)),SLOT(onDirectoryLoaded(QString)));
    connect(m_watcher,SIGNAL(directoryChanged(QString)),SLOT(refresh(QString)));
    connect(m_watcher,SIGNAL(fileChanged(QString)),SLOT(refresh(QString)));
    fs()->setRootPath(QDir::rootPath());
    fs()->setReadOnly(false);
    fs()->setFilter(QDir::AllDirs | QDir::AllEntries | QDir::System | QDir::Hidden);
}

QModelIndex ProxyFileSystemModel::index(int row, int column, const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->index(fs()->rootPath()));
    return QIdentityProxyModel::index(row, column, proxyRootIndex);
}

QModelIndex ProxyFileSystemModel::parent(const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->index(fs()->rootPath()));
    return proxyRootIndex;
}

int ProxyFileSystemModel::columnCount(const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->index(fs()->rootPath()));
    return QIdentityProxyModel::columnCount(proxyRootIndex);
}

int ProxyFileSystemModel::rowCount(const QModelIndex &) const {
    QModelIndex proxyRootIndex = mapFromSource(fs()->index(fs()->rootPath()));
    return QIdentityProxyModel::rowCount(proxyRootIndex);
}

void ProxyFileSystemModel::refresh(QString){
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
    QVariant result = fs()->data(fs()->index(filePath,column));
    m_watcher->addPath(filePath);
    return result.toString();
}

QVariant ProxyFileSystemModel::headerData(int index, Qt::Orientation orient, int role) const{
    return QIdentityProxyModel::headerData(index, orient, role);
}
