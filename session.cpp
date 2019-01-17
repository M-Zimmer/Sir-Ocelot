#include "session.h"

Session::Session():m_window(m_engine),m_settings("settings.ini",QSettings::IniFormat){
   m_engine.rootContext()->setContextProperty("AppWindow", &m_window);
}
