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

import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog {
    id: dialog
    onAccepted: {
        webClient.setValue("webclient/baseUrl",myTextField.text)
        webClient.setValue("webclient/path",path.text);
        webClient.setValue("webclient/queryOn",queryOn.text);
        webClient.setValue("webclient/queryOff",queryOff.text);
    }
    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: dialog.width
            spacing: Theme.paddingLarge

            DialogHeader {
                title: qsTr("Settings")

            }
            TextField {
                id:myTextField
                Label {
                    text: qsTr('Base url:')
                    width: parent.width
                    anchors.bottom:parent.top

                    }
                width:parent.width
                text: webClient.value("webclient/baseUrl") ? webClient.value("webclient/baseUrl") : ""
                placeholderText: qsTr("http://192.168.1.1/")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall



            }
            TextField {
                id:path
                Label {
                    text: qsTr('path:')
                    width: parent.width
                    anchors.bottom:parent.top

                    }
                width:parent.width
                text: webClient.value("webclient/path") ? webClient.value("webclient/path") : ""
                placeholderText: qsTr("/LED")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall



            }
            TextField {
                id:queryOn
                Label {
                    text: qsTr('query on')
                    width: parent.width
                    anchors.bottom:parent.top

                    }
                width:parent.width
                text: webClient.value("webclient/queryOn") ? webClient.value("webclient/queryOn") : ""
                placeholderText: qsTr("?ACTION=ON")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall



            }
            TextField {
                id:queryOff
                Label {
                    text: qsTr('query off')
                    width: parent.width
                    anchors.bottom:parent.top

                    }
                width:parent.width
                text: webClient.value("webclient/queryOff") ? webClient.value("webclient/queryOff") : ""
                placeholderText: qsTr("?ACTION=OFF")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall



            }
        }
    }
}
