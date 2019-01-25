#ifndef PROXYFILESYSTEMMODEL_H
#define PROXYFILESYSTEMMODEL_H
#include <QFileSystemModel>
#include <QIdentityProxyModel>
#include <QDebug>
#include <QFileSystemWatcher>

class ProxyFileSystemModel : public QIdentityProxyModel{
    Q_OBJECT
    public:
        ProxyFileSystemModel(QObject* parent = 0);
        Q_INVOKABLE QString fileData(QString filePath, int column);
        Q_INVOKABLE QString root(){ return fs()->rootPath();}
        Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation = Qt::Horizontal, int role = Qt::DisplayRole) const override;
        virtual QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
        virtual QModelIndex parent(const QModelIndex &child) const override;
        virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override;
        virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    private slots:
        void refresh(QString);
        void onDirectoryLoaded(const QString);
    private:
        QFileSystemModel* fs() const { return qobject_cast<QFileSystemModel*>(sourceModel()); }
        QFileSystemWatcher* m_watcher;
};

#endif // PROXYFILESYSTEMMODEL_H
