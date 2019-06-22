#include "pixmapprovider.h"
#include <QIcon>
#include <QDebug>

PixmapProvider::PixmapProvider():QQuickImageProvider(QQuickImageProvider::Pixmap,
                                 QQuickImageProvider::ForceAsynchronousImageLoading)
{

}

QPixmap PixmapProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize){
    if (id == "NULL"){
        QPixmap px(16,16);
        px.fill(Qt::transparent);
        size->setWidth(px.width());
        size->setHeight(px.height());
        return px.scaled(requestedSize);
    }
    PxHash::const_iterator it = m_iconPxHash.find(id);
    size->setWidth(it.value().width());
    size->setHeight(it.value().height());
    return it.value().scaled(requestedSize);
}

QUrl PixmapProvider::getImageSource(const QString& provId, const QVariant& icon){
    QIcon realIcon = icon.value<QIcon>();
    QString result = "image://%1/%2";
    QPixmap imagePx = realIcon.pixmap(realIcon.actualSize(realIcon.availableSizes().first()));
    if (imagePx.isNull()) return QUrl(result.arg(provId).arg("NULL"));
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
