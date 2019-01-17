#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QDebug>
#include "session.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<ProxyFileSystemModel>("FSModel", 1, 0, "FileSystemModel");
    QApplication::instance()->installNativeEventFilter(new NativeFilter());
    app.setApplicationDisplayName("Derp");
    Session session;
    return app.exec();
}
