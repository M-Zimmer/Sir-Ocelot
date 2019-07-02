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

#include "session.h"

Session* Session::_instance = nullptr;

Session::Session():m_window(m_engine, this),m_settings("./settings.ini",QSettings::IniFormat, this){
}

Session* Session::instance(){
    if (_instance == nullptr){
        _instance = new Session();
    }
    return Session::_instance;
}

void Session::disposeOfInstance(){
    if (_instance != nullptr){
        delete _instance;
        _instance = nullptr;
    }
}

void Session::saveToFavorites(QString name, QVariant tabUrls){
    QVariantList list = favoritePanels().value<QVariantList>();
    QVariantList newEntry;
    newEntry.push_back(name);
    newEntry.push_back(tabUrls);
    list.push_back(newEntry);
    m_settings.beginGroup("FavoritePanels");
    m_settings.remove("");
    m_settings.endGroup();
    m_settings.beginWriteArray("FavoritePanels");
    int i = 0;
    for (auto it = list.cbegin(); it != list.cend(); ++it){
        m_settings.setArrayIndex(i);
        QVariantList entry = it->value<QVariantList>();
        m_settings.setValue("name", entry.front());
        m_settings.setValue("tabUrls", entry.back().value<QVariantList>());
        i++;
    }
    m_settings.sync();
    m_settings.endArray();
}

void Session::saveToRecentlyClosed(QString name, QVariant tabUrls){
    QVariantList list = recentlyClosedPanels().value<QVariantList>();
    if (list.size() >= 10) list.pop_back();
    QVariantList newEntry;
    newEntry.push_back(name);
    newEntry.push_back(tabUrls);
    list.push_front(newEntry);
    m_settings.beginGroup("RecentlyClosed");
    m_settings.remove("");
    m_settings.endGroup();
    m_settings.beginWriteArray("RecentlyClosed");
    int i = 0;
    for (auto it = list.cbegin(); it != list.cend(); ++it){
        m_settings.setArrayIndex(i);
        QVariantList entry = it->value<QVariantList>();
        m_settings.setValue("name", entry.front());
        m_settings.setValue("tabUrls", entry.back().value<QVariantList>());
        i++;
    }
    m_settings.sync();
    m_settings.endArray();
}

QVariant Session::favoritePanels(){
    int size = m_settings.beginReadArray("FavoritePanels");
    QVariantList result;
    for (int i = 0; i < size; i++){
        QVariantList resultEntry;
        m_settings.setArrayIndex(i);
        QString name = m_settings.value("name").toString();
        QVariant tabUrls = m_settings.value("tabUrls");
        resultEntry.append(name);
        resultEntry.append(tabUrls);
        result.push_back(resultEntry);
    }
    m_settings.endArray();
    return result;
}

QVariant Session::recentlyClosedPanels(){
    int size = m_settings.beginReadArray("RecentlyClosed");
    QVariantList result;
    for (int i = 0; i < size; i++){
        QVariantList resultEntry;
        m_settings.setArrayIndex(i);
        QString name = m_settings.value("name").toString();
        QVariant tabUrls = m_settings.value("tabUrls");
        resultEntry.append(name);
        resultEntry.append(tabUrls);
        result.push_back(resultEntry);
    }
    m_settings.endArray();
    return result;
}
