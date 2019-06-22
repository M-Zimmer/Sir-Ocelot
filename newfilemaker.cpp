#include "newfilemaker.h"
#include <QMetaType>
#include <QDir>
#include <QTextStream>
#include <QProcess>
#include <QVector>
#include <QDebug>

NewFileMaker::NewFileMaker(Type type)
:m_type(type){
    switch(m_type){
        case NFM_FOLDER:{
            setDisplayName("Folder");
            break;
        }
        case NFM_LINK:{
            setDisplayName("Shortcut");
            setFileExt(".lnk");
            break;
        }
    }
}

NewFileMaker::NewFileMaker(QString extension, Type type, QVariant data, QString displayName)
:m_ext(extension),m_type(type), m_displayStr(displayName){

    switch(data.type()){
        case QMetaType::QString: {
            if (m_type == NFM_COMMAND) m_cmd = data.value<QString>();
            else if (m_type == NFM_FILENAME){
              m_fName = data.value<QString>();
              QFileInfo fInfo(m_fName);
              if (fInfo.isRelative()){
                m_fName = QDir::rootPath() + "Windows/ShellNew/" + m_fName;
              }
            }
            break;
        }
        case QMetaType::QByteArray: { m_data = data.value<QByteArray>(); break; }
    }
}

bool NewFileMaker::createNewObj(QString path, QString newName, QString linkName){
    qDebug() << path << newName << linkName;
    if (newName.isEmpty())
        if (!displayName().isEmpty())
            newName = "New " + displayName();
        else newName = "New file";
    if (type() != NFM_LINK)
        newName = getAvailableName(path, newName);
    qDebug() << path << newName << linkName;
    switch(m_type){
        case NFM_FOLDER:{ return _createFolder(path, newName); break;}
        case NFM_LINK: {return _createLink(path, newName, linkName); break;}
        case NFM_COMMAND: { return _createFromCommand(path); break;}
        case NFM_NULLFILE: { return _createNullFile(path, newName); break;}
        case NFM_FILENAME: { return _createFromTemplate(path, newName); break;}
        case NFM_DATA: { return _createFromData(path, newName); break;}
    }
    return true;
}

QString NewFileMaker::getAvailableName(QString path, QString newName){
    QString workPath = QDir::currentPath();
    qDebug() << path << newName;
    QDir::setCurrent(path);
    QFileInfo fInfo(newName);
    if ("." + fInfo.suffix() != extension()) newName += extension();
    if (QFileInfo::exists(newName)){
        QFileInfo temp(newName);
        QString original;
        if (!temp.path().isEmpty()) original = temp.path() + "/";
        if (!extension().isEmpty()) original += temp.completeBaseName();
        else original += temp.fileName();
        qDebug() << original;
        quint64 i = 2;
        do{
            newName = original + QString(" (%1)").arg(QString::number(i));
            if (!extension().isEmpty()) newName += extension();
            i++;
        }while(QFileInfo::exists(newName));
    }
    QDir::setCurrent(workPath);
    qDebug() << newName;
    return newName;
}

bool NewFileMaker::_createFolder(QString path, QString newName){
    QDir curDir(path);
    QFileInfo fInfo(newName);
    if (fInfo.isRelative()) return curDir.mkpath(newName);
    else {
        QDir dir(newName);
        QString dirName = dir.dirName();
        dir.cdUp();
        return dir.mkdir(dirName);
    }
}

bool NewFileMaker::_createLink(QString path, QString newName, QString linkName){
    QFileInfo fInfo(newName);
    QString workPath = QDir::currentPath();
    bool status = false;
    if (fInfo.isRelative()){
        QDir::setCurrent(path);
        if (linkName.isEmpty())
            linkName = fInfo.path() + "/" + fInfo.completeBaseName() + " - " + m_displayStr + ".lnk";
        qDebug() << "linkName" << linkName;
        linkName = getAvailableName(path, linkName);
        qDebug() << "linkName" << linkName;
        status = QFile::link(newName, linkName);
        QDir::setCurrent(workPath);
        return status;
    }else{
        if (linkName.isEmpty())
            linkName = fInfo.path() + "/" + fInfo.completeBaseName() + " - " + m_displayStr + ".lnk";
        qDebug() << "linkName" << linkName;
        linkName = getAvailableName(path, linkName);
        qDebug() << "linkName" << linkName;
        return QFile::link(newName, linkName);
    }
}

bool NewFileMaker::_createNullFile(QString path, QString newName){
    QFileInfo fInfo(newName);
    QString workPath = QDir::currentPath();
    bool status = false;
    QString finalNewName = newName;
    //if (fInfo.suffix() != extension()) finalNewName += extension();
    QFile f(finalNewName);
    if (fInfo.isRelative()){
        QDir::setCurrent(path);
        status = f.open(QIODevice::NewOnly);
        if(status){
            f.close();
        }
        QDir::setCurrent(workPath);
        return status;
    }else{
        if (f.open(QIODevice::NewOnly)){
            f.close();
            return true;
        }else return false;
    }
}

bool NewFileMaker::_createFromTemplate(QString path, QString newName){
    QFileInfo fInfo(newName);
    QString workPath = QDir::currentPath();
    bool status = false;
    QString finalNewName = newName;
    //if (fInfo.suffix() != extension()) finalNewName += extension();
    if (fInfo.isRelative()){
        QDir::setCurrent(path);
        status = QFile::copy(m_fName, finalNewName);
        QDir::setCurrent(workPath);
        return status;
    }else{
        return QFile::copy(m_fName, finalNewName);
    }
}

bool NewFileMaker::_createFromCommand(QString path){
    QProcess::startDetached(command().replace("%1", path)); // CONSIDER USING QREGULAREXPRESSION INSTEAD FOR PATTERN MATCHING
    return true;
}

bool NewFileMaker::_createFromData(QString path, QString newName){
    QFileInfo fInfo(newName);
    QString workPath = QDir::currentPath();
    bool status = false;
    qint64 bytesWritten = 0;
    QString finalNewName = newName;
    //if (fInfo.suffix() != extension()) finalNewName += extension();
    QFile f(finalNewName);
    if (fInfo.isRelative()){
        QDir::setCurrent(path);
        status = f.open(QIODevice::NewOnly);
        if(status){
            bytesWritten = f.write(m_data);
            if (bytesWritten == data().size()) status = true;
            else status = false;
            f.close();
        }
        QDir::setCurrent(workPath);
        return status;
    }else{
        if (f.open(QIODevice::NewOnly)){
            bytesWritten = f.write(data());
            f.close();
            if (bytesWritten == data().size()) return true;
            else return false;
        }else return false;
    }
}
