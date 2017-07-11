/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include "webclient.h"
#include "controllistmodel.h"
#include "settings.h"
#include <QGuiApplication>
#include <sailfishapp.h>
#include <QtQuick/QQuickView>
#include <QDebug>
#include <QtNetwork>
#include <QUrl>
int main(int argc, char *argv[])
{

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).
    Settings *settings = new Settings();

    if(settings->getSettings()->value("webclient/baseUrl","").toString() != "") {
        settings->setValue("webclient0/getUrl",settings->value("webclient/baseUrl").toString() + settings->value("webclient/path").toString()+settings->value("webclient/queryOn").toString());
        settings->setValue("webclient0/buttonText","On");
        settings->setValue("webclient0/sectionHeader","DefaultSection");
        settings->setValue("webclient1/getUrl",settings->value("webclient/baseUrl").toString() + settings->value("webclient/path").toString()+settings->value("webclient/queryOff").toString());
        settings->setValue("webclient1/buttonText","Off");
        settings->setValue("webclient1/sectionHeader","DefaultSection");
        settings->setValue("CoverOn","0");
        settings->setValue("CoverOff","1");
        settings->getSettings()->remove("webclient");
    }
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc,argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    Webclient *w = new Webclient();
    ControlListModel *bModel = new  ControlListModel();

    app->connect(w,SIGNAL(received(QString,QString,int)),bModel,SLOT(received(QString,QString,int)));
    view->rootContext()->setContextProperty("webclient",w);
    view->rootContext()->setContextProperty("bModel",bModel);
    view->rootContext()->setContextProperty("settings",settings);
    view->setSource(SailfishApp::pathTo("qml/harbour-d1webclient.qml"));
    QObject *object = view->rootObject();
    QVariant returnedValue;
    QMetaObject::invokeMethod(object, "pushAttached",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, "pages/ThirdPage.qml"));
    view->show();
    QObject *wv = object->findChild<QObject*>("webViewObj");
    app->connect(w,&Webclient::httpDone,[=](QNetworkReply* r) {
          QMetaObject::invokeMethod(wv, "loadHtml",
                Q_ARG(QString, r->readAll()),
                Q_ARG(QUrl,QUrl(r->request().url())));
          r->close();
          emit w->httpRead();
    } );
    return app->exec();
}
