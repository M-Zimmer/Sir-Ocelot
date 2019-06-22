#ifndef QUICKFILEWATCHER_H
#define QUICKFILEWATCHER_H
#include <QFileSystemWatcher>

class QuickFileWatcher : public QFileSystemWatcher
{
    Q_OBJECT
public:
    QuickFileWatcher(QObject* parent = nullptr);
    Q_INVOKABLE bool add(QString path);
    Q_INVOKABLE void clear();
};

#endif // QUICKFILEWATCHER_H
