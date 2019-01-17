#ifndef PROXYFILESYSTEMMODEL_H
#define PROXYFILESYSTEMMODEL_H
#include <QFileSystemModel>
#include <QIdentityProxyModel>
#include <QDebug>

class ProxyFileSystemModel : public QIdentityProxyModel{
    Q_OBJECT
    public:
        ProxyFileSystemModel(QObject* parent = 0);
        virtual QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
        virtual QModelIndex parent(const QModelIndex &child) const override;
        virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override;
        virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
};

#endif // PROXYFILESYSTEMMODEL_H
