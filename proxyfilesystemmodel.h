#ifndef PROXYFILESYSTEMMODEL_H
#define PROXYFILESYSTEMMODEL_H
#include <QIdentityProxyModel>
#include <QDebug>
#include <QFileSystemWatcher>
#include <QFileSystemModel>

class ProxyFileSystemModel : public QIdentityProxyModel{
    Q_OBJECT
    public:
        ProxyFileSystemModel(QObject* parent = 0);
        Q_PROPERTY(QString rootPath READ rootPath WRITE setRootPath NOTIFY rootPathChanged)
        Q_INVOKABLE QString fileData(QString filePath, int column);
        Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation = Qt::Horizontal, int role = Qt::DisplayRole) const override;
        Q_INVOKABLE void cdUp();
        Q_INVOKABLE void fileDelete(QVariant);
        Q_INVOKABLE void fileCopy(QVariant, QString);
        Q_INVOKABLE void fileRename(QModelIndex, QString);
        Q_INVOKABLE void fileMove(QVariant, QString);
        Q_INVOKABLE int getRowCount(){ return rowCount();}
        virtual QString rootPath() const { return fs()->rootPath(); }
        virtual QModelIndex setRootPath(const QString& path){ return fs()->setRootPath(path);}
        virtual QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
        virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override;
        virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    signals:
        void rootPathChanged(const QString & path);
    private slots:
        void refresh(QString);
        void onDirectoryLoaded(const QString);
    private:
        QFileSystemModel* fs() const { return qobject_cast<QFileSystemModel*>(sourceModel()); }
        QFileSystemWatcher* m_watcher;
};

#endif // PROXYFILESYSTEMMODEL_H
