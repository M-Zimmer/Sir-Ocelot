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

#ifndef SESSION_H
#define SESSION_H
#include "appwindow.h"
#include <QSettings>

class Session: public QObject{
    Q_OBJECT
    public:
        Session();
        void saveToFavorites(QString name, QVariant tabUrls);
        void saveToRecentlyClosed(QString name, QVariant tabUrls);
        QVariant favoritePanels();
        QVariant recentlyClosedPanels();
    private:
        QQmlEngine m_engine;
        AppWindow m_window;
        QSettings m_settings;
};
#endif // SESSION_H
