#ifndef SESSION_H
#define SESSION_H
#include "appwindow.h"
#include <QSettings>

class Session: public QObject{
    Q_OBJECT
    public:
        Session();
    private:
        AppWindow m_window;
        QSettings m_settings;
};
#endif // SESSION_H
