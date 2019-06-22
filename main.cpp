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
