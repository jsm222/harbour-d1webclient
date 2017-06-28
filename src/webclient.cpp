#include "webclient.h"
Webclient::Webclient(QObject *parent) : QObject(parent)
{
    _mSettings = new QSettings("harbour-d1webclient", "harbour-d1webclient");
}
void Webclient::webConnect(QString command) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(requestReceived(QNetworkReply*)));
    manager->get(QNetworkRequest(QUrl(value("webclient/baseUrl").toString()+value("webclient/path").toString()+value("webclient/query"+command).toString())));
}

void Webclient::requestReceived(QNetworkReply* reply)
{
    QVariant status =  reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(status.toInt() != 200 && status.toInt() != 404) {
        status = QVariant();
        status.setValue(reply->error());

    }
    emit(Webclient::received(reply->request().url().path() + " " + reply->request().url().query(), status.toString()));
}
QVariant Webclient::value(const QString &key)
{
   return _mSettings->value(key);
}

void Webclient::setValue(const QString &key, const QVariant &value)
{
   _mSettings->setValue(key, value);
}

