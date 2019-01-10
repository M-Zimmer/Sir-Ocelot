#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QDebug>
#include "session.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::instance()->installNativeEventFilter(new NativeFilter());
    app.setApplicationDisplayName("Derp");
    Session session;
    return app.exec();
}
