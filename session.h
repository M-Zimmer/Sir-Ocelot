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
