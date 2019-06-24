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

#include <QGuiApplication>
#include "session.h"
#include "quickfilewatcher.h"
#include <QProcess>
#include <QStandardPaths>

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling, true);
    QGuiApplication app(argc, argv);
    app.setApplicationVersion("0.3.0");
    app.setOrganizationName("ZiMMeR_7");
    QGuiApplication::instance()->installNativeEventFilter(new NativeFilter());
    qmlRegisterUncreatableType<QStandardPaths>("StdPaths", 1, 0, "QStandardPaths", "QStandardPaths cannot be instantiated.");
    qmlRegisterType<QuickFileWatcher>("FWatcher", 1, 0, "QuickFileWatcher");
    app.setApplicationDisplayName("Sir Ocelot File Manager");

    Session session;
    return app.exec();
}
