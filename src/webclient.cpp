#include "webclient.h"
Webclient::Webclient(QObject *parent) : QObject(parent)
{
    _mSettings = new QSettings("computer.schmitz", "computer.schmitz.harbour-d1webclient");
}
void Webclient::webConnect(QString command) {
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(requestReceived(QNetworkReply*)));
    manager->get(QNetworkRequest(QUrl(value("webclient/baseUrl").toString()+value("webclient/path").toString()+value("webclient/query"+command).toString())));
}

void Webclient::requestReceived(QNetworkReply* reply) {
    QString respBodySnip ="";
    QVariant status =  reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(status.toInt() != 200 && status.toInt() != 404) {
        status = QVariant();
        status.setValue(reply->error());

    } else {

      //respBody = QString(reply->readAll());
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

