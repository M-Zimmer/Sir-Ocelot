#include "proxyfilesystemmodel.h"

ProxyFileSystemModel::ProxyFileSystemModel(QObject*){
    setSourceModel(new QFileSystemModel);
    fs()->setReadOnly(false);
    fs()->setFilter(QDir::AllDirs | QDir::AllEntries | QDir::System | QDir::Hidden);
}

QModelIndex ProxyFileSystemModel::index(int row, int column, const QModelIndex &) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::index(row, column, proxyRootIndex);
}

QModelIndex ProxyFileSystemModel::parent(const QModelIndex &) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return proxyRootIndex;
}

int ProxyFileSystemModel::columnCount(const QModelIndex &) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::columnCount(proxyRootIndex);
}

int ProxyFileSystemModel::rowCount(const QModelIndex &) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::rowCount(proxyRootIndex);
}
