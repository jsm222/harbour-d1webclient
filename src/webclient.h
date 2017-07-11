#ifndef WEBCLIENT_H
#define WEBCLIENT_H
#include <QtQuick>
#include <QObject>
#include <QNetworkReply>
#include <QString>
#include "settings.h"
class Webclient : public QObject
{
    Q_OBJECT

public:
    explicit Webclient(QObject *parent = 0);
    Q_INVOKABLE void webConnect(int set,int index);

signals:
    void received(QString query,QString status,int index);
    void httpDone(QNetworkReply* reply,int index);
    void httpRead();
public slots:
    void requestReceived(QNetworkReply *reply);
    void authenticate(QNetworkReply* reply,QAuthenticator* authenticater);
private:
    Settings *m_settings;
    QNetworkAccessManager *m_manager;
    int mIndex;
    int mSet;

};

#endif // WEBCLIENT_H
