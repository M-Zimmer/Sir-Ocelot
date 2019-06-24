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
