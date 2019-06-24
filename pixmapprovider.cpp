// Copyright 2018-2019 Max Mazur
/*
    This file is part of Sir Ocelot File Manager.

    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sir Ocelot File Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

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
