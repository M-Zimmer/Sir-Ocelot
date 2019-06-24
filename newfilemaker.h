// Copyright 2018-2019 Max Mazur
/*
    This file is part of Sir Ocelot File Manager.

    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sir Ocelot File Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

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
