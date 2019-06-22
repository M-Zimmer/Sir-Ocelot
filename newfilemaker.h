#ifndef NEWFILEMAKER_H
#define NEWFILEMAKER_H
#include <QString>
#include <QVariant>

class NewFileMaker
{
    public:
        enum Type {NFM_FOLDER, NFM_LINK, NFM_COMMAND, NFM_NULLFILE,
                   NFM_FILENAME, NFM_DATA};
       // Q_ENUM(Type)
        NewFileMaker(Type type = NFM_FOLDER);
        NewFileMaker(QString extension, Type type = NFM_NULLFILE, QVariant data = QVariant(), QString displayName = "");
        bool createNewObj(QString path, QString newName, QString linkName = "");
        void setType(Type val){ m_type = val;}
        void setFileExt(QString val){ m_ext = val;}
        void setDisplayName(QString val){ m_displayStr = val;}
        void setCommand(QString val){ m_cmd = val;}
        void setFileName(QString val){ m_fName = val;}
        void setData(QByteArray val){ m_data = val;}
        QString getAvailableName(QString path, QString newName);
        Type type() const {return m_type;}
        QString extension() const {return m_ext;}
        QString displayName() const {return m_displayStr;}
        QString command() const {return m_cmd;}
        QString fileName() const {return m_fName;}
        QByteArray data() const {return m_data;}
    private:
        bool _createFolder(QString path, QString newName);
        bool _createLink(QString path, QString newName, QString linkName);
        bool _createNullFile(QString path, QString newName);
        bool _createFromTemplate(QString path, QString newName);
        bool _createFromCommand(QString path);
        bool _createFromData(QString path, QString newName);
        Type m_type;
        QString m_ext;
        QString m_displayStr;
        QString m_cmd;
        QString m_fName;
        QByteArray m_data;
};

#endif // NEWFILEMAKER_H
