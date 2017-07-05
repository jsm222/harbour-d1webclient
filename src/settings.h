#ifndef SETTTINGS_H
#define SETTTINGS_H
#include <QSettings>
#include <QObject>
class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0);
    QSettings* getSettings();
    Q_INVOKABLE void remove(int index);

    Q_INVOKABLE QVariant value(const QString &key);
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
public slots:
private:
    QSettings *_mSettings;
};

#endif // SETTTINGS_H
