#ifndef PIXMAPPROVIDER_H
#define PIXMAPPROVIDER_H
#include <QQuickImageProvider>

class PixmapProvider : public QQuickImageProvider
{
    typedef QHash <qintptr, QString> IdHash;
    typedef QHash <QString, QPixmap> PxHash;
    public:
        PixmapProvider();
        QUrl getImageSource(const QString&, const QVariant&);
        virtual QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
    private:
        IdHash m_iconIdHash;
        PxHash m_iconPxHash;
};

#endif // PIXMAPPROVIDER_H
