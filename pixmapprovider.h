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

#ifndef PIXMAPPROVIDER_H
#define PIXMAPPROVIDER_H
#include <QQuickImageProvider>

class PixmapProvider : public QQuickImageProvider
{
    typedef QHash <qint64, QString> IdHash;
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
