#include "quickfilewatcher.h"

QuickFileWatcher::QuickFileWatcher(QObject* parent): QFileSystemWatcher(parent)
{

}

bool QuickFileWatcher::add(QString path){
  return addPath(path);
}

void QuickFileWatcher::clear(){
    if (!directories().isEmpty()) removePaths(directories());
    if (!files().isEmpty()) removePaths(files());
}
