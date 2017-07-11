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
        var i = getIndex();
        if(getAction() === "copy") {
            i = bModel.nextIndex()
        }

        settings.setValue(("webclient%1/sectionHeader").arg(i),mySectionHeader.text !== "" ? mySectionHeader.text : qsTr("DefaultSection"))
        settings.setValue(("webclient%1/getUrl").arg(i),getUrl.text)
        settings.setValue(("webclient%1/buttonText").arg(i),button1.text !== "" ? button1.text : qsTr("New control %1").arg(i));
        settings.setValue(("webclient%1/username").arg(i),username.text);
        settings.setValue(("webclient%1/password").arg(i),password.text);
        if(cBox.value == "CoverOn") settings.setValue("CoverOn",i);
        if(cBox.value == "CoverOff") settings.setValue("CoverOff",i);


        bModel.settingsChanged(i,getListIndex());

    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height
        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: dialog.width
            spacing: Theme.paddingLarge

            DialogHeader {
                title: qsTr("Request settings")

            }
            TextField {
                id:mySectionHeader
                Label {
                    text: qsTr('Section text:')
                    width: parent.width
                    anchors.bottom:parent.top

                }
                width:parent.width
                text:settings.value("webclient%1/sectionHeader".arg(getIndex())) ? settings.value("webclient%1/sectionHeader".arg(getIndex())) : ""
                placeholderText: qsTr("Section")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                EnterKey.enabled: text.length >0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: getUrl.focus = true


            }
            TextField {
                id:getUrl
                Label {
                    text: qsTr('Url')
                    width: parent.width
                    anchors.bottom:parent.top

                }
                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: username.focus = true
                width:parent.width
                text: settings.value("webclient%1/getUrl".arg(getIndex())) ? settings.value("webclient%1/getUrl".arg(getIndex())) : ""
                placeholderText:"http://192.168.1.1/LED/ACTION=ON"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall


            }
            TextField {
                id:username
                Label {
                    text: qsTr('Username')
                    width: parent.width
                    anchors.bottom:parent.top

                }
                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: password.focus = true
                width:parent.width
                text: settings.value("webclient%1/username".arg(getIndex())) ? settings.value("webclient%1/username".arg(getIndex())) : ""
                placeholderText:"user"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall


            }
            TextField {
                id:password
                Label {
                    text: qsTr('Password')
                    width: parent.width
                    anchors.bottom:parent.top


                }
                echoMode:TextInput.PasswordEchoOnEdit
                EnterKey.enabled: true
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: button1.focus = true
                width:parent.width
                text: settings.value("webclient%1/password".arg(getIndex())) ? settings.value("webclient%1/password".arg(getIndex())) : ""
                placeholderText:"password"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall


            }




            TextField {
                id:button1
                Label {
                    text: qsTr('Text')
                    width: parent.width
                    anchors.bottom:parent.top

                }
                width:parent.width
                text: settings.value("webclient%1/buttonText".arg(getIndex())) ? settings.value("webclient%1/buttonText".arg(getIndex())) : ""
                placeholderText: qsTr("On")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall



            }
            ComboBox {
                id:cBox
                label : "CoverAction"
                currentIndex: getCboxIndex()
                menu: ContextMenu {
                       MenuItem { text: "None" }
                       MenuItem { text: "CoverOn" }
                       MenuItem { text: "CoverOff" }

                   }
            }

         }
    }
    function getCboxIndex() {
      if(getAction() === "edit") {

        if(parseInt(settings.value("CoverOn")) === getIndex()) {
            return 1;
        }
        else if(parseInt(settings.value("CoverOff")) === getIndex()) {
            return 2;
        }

    }
      return 0;
    }

}
