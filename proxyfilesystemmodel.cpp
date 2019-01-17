#include "proxyfilesystemmodel.h"

ProxyFileSystemModel::ProxyFileSystemModel(QObject* parent){
    setSourceModel(new QFileSystemModel);
}

QModelIndex ProxyFileSystemModel::index(int row, int column, const QModelIndex &parent) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::index(row, column, proxyRootIndex);
}

QModelIndex ProxyFileSystemModel::parent(const QModelIndex &child) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    qDebug() << child;
    return proxyRootIndex;
}

int ProxyFileSystemModel::columnCount(const QModelIndex &parent) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::columnCount(proxyRootIndex);
}

int ProxyFileSystemModel::rowCount(const QModelIndex &parent) const {
    QFileSystemModel* fs = qobject_cast<QFileSystemModel*>(sourceModel());
    QModelIndex proxyRootIndex = mapFromSource(fs->index(fs->rootPath()));
    return QIdentityProxyModel::rowCount(proxyRootIndex);
}
