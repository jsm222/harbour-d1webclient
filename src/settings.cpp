#include "settings.h"

Settings::Settings(QObject *parent) : QObject(parent)
{
    _mSettings = new QSettings("harbour-d1webclient", "harbour-d1webclient");
}
QVariant Settings::value(const QString &key)
{
    return _mSettings->value(key);
}

void Settings::setValue(const QString &key, const QVariant &value)
{
    _mSettings->setValue(key, value);
}


QSettings* Settings::getSettings() {
    return _mSettings;
}
void Settings::remove(int index) {
    _mSettings->remove(QString("webclient%1").arg(index));
}

