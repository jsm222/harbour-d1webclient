#include "webclient.h"
#include "settings.h"
Webclient::Webclient(QObject *parent) : QObject(parent)
{
    m_manager = new QNetworkAccessManager(this);
    m_settings = new Settings();
    connect(m_manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(requestReceived(QNetworkReply*)));

}
void Webclient::webConnect(int set,int index) {
    mIndex= index;
    mSet = set;
    m_manager->clearAccessCache();
    connect(m_manager,SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)),this,SLOT(authenticate(QNetworkReply*,QAuthenticator*)));
    m_manager->get(QNetworkRequest(QUrl(
                                       m_settings->value(QString("webclient%1/getUrl").arg(set)).toString())
                                   ));

}
void Webclient::authenticate(QNetworkReply* reply,QAuthenticator* authenticater) {
    Q_UNUSED(reply);

    authenticater->setPassword(m_settings->value(QString("webclient%1/password").arg(mSet)).toString());
    authenticater->setUser(m_settings->value(QString("webclient%1/username").arg(mSet)).toString());
    disconnect(m_manager,SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)),this,SLOT(authenticate(QNetworkReply*,QAuthenticator*)));

}

void Webclient::requestReceived(QNetworkReply *reply)
{
    QVariant status =  reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(status.toInt() != 200 && status.toInt() != 404) {
        status = QVariant();
        status.setValue(reply->error());

    }
    emit(Webclient::received(reply->request().url().path() + " " + reply->request().url().query(), status.toString(),mIndex));
    emit(Webclient::httpDone(reply,mIndex));
}

