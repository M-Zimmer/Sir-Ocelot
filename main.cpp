#include <QApplication>
#include "session.h"

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling, true);
    QApplication app(argc, argv);
    qmlRegisterType<ProxyFileSystemModel>("FSModel", 1, 0, "FileSystemModel");
    QApplication::instance()->installNativeEventFilter(new NativeFilter());
    app.setApplicationDisplayName("Sir Ocelot File Manager");
    Session session;
    return app.exec();
}
