#ifndef WEBCLIENT_H
#define WEBCLIENT_H

#include <QObject>
#include <QNetworkReply>
#include <QString>
#include <QSettings>

class Webclient : public QObject
{
    Q_OBJECT

public:
    explicit Webclient(QObject *parent = 0);
    Q_INVOKABLE void webConnect(QString command);
    Q_INVOKABLE QVariant value(const QString &key);
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
signals:
    void baseUrlChanged();
    void received(QString query,QString status);
public slots:
    void requestReceived(QNetworkReply* reply);
private:
    QString m_baseUrl;
    QSettings *_mSettings;

};

#endif // WEBCLIENT_H
