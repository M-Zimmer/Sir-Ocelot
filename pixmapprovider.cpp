#include "pixmapprovider.h"
#include <QIcon>
#include <QDebug>

PixmapProvider::PixmapProvider():QQuickImageProvider(QQuickImageProvider::Pixmap,
                                 QQuickImageProvider::ForceAsynchronousImageLoading)
{

}

QPixmap PixmapProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize){
    PxHash::const_iterator it = m_iconPxHash.find(id);
    size->setWidth(it.value().width());
    size->setHeight(it.value().height());
    return it.value().scaled(requestedSize);
}

QUrl PixmapProvider::getImageSource(const QString& provId, const QVariant& icon){
    QIcon realIcon = icon.value<QIcon>();
    QString result = "image://%1/%2";
    QPixmap imagePx = realIcon.pixmap(realIcon.actualSize(realIcon.availableSizes().first()));
    IdHash::const_iterator it = m_iconIdHash.find(imagePx.cacheKey());
    if (it != m_iconIdHash.end()){
        return QUrl(result.arg(provId).arg(it.value()));
    }
    else{
        QString imageId = QString("IMAGE%1").arg(m_iconIdHash.size());
        m_iconIdHash.insert(imagePx.cacheKey(),imageId);
        m_iconPxHash.insert(imageId,imagePx);
        return QUrl(result.arg(provId).arg(imageId));
    }
}
