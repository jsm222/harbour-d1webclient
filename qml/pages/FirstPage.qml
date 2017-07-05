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
Page {
    // The delegate for each section header
    Component {
        id: sectionHeading
        Rectangle {
            width: page.width
            height: childrenRect.height
            color: listView.hSection == section ? Theme.primaryColor : Theme.secondaryColor
            Text {
                text:section
                font.bold: true
                font.pixelSize: 20
            }


        }
    }




    id: page
    allowedOrientations: Orientation.All
    SilicaListView {
        property int hButtonId;
        property string hSection:"";
        VerticalScrollDecorator {}

        model:bModel
        header:PageHeader {
            title: qsTr("Remote Control")
        }
        BusyIndicator {
            size:BusyIndicatorSize.Large
            id:bIndicator
            anchors.centerIn: parent
            running: false
        }

        RemorsePopup { id: remorse }

        PullDownMenu {
            width:page.width

            MenuItem {
                text: qsTr("Add control")
                onClicked: {
                    setIndex(bModel.nextIndex())

                    setListIndex(-1)
                    setAction("Add")
                    pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Open external browser")
                onClicked: {
                    Qt.openUrlExternally(settings.value("webclient%1/getUrl".arg(listView.hButtonId)))
                }
            }
            MenuItem {
                text: qsTr("Remove section")
                visible: listView.hSection !== "";
                onClicked: {
                    var cHsection = listView.hSection;
                    if(cHsection !== "") {
                        remorse.execute("Removing section " + cHsection, function() { bModel.removeSection(cHsection);});
                    }
                }
            }
        }

        anchors.fill: parent

        width:page.width
        id:listView



        delegate: ListItem {
            RemorseItem { id: remorseItem }
            function showRemorseItem() {


            remorseItem.execute(lItem,"Removing",function() {
                 setAction("Remove");
                var cIdx = index,cBid = buttonId;
                settings.remove(parseInt(cBid));bModel.removeRows(cIdx,1);

            },3000);
            }
            id:lItem
            width:page.width
            onClicked:{
                bIndicator.running = true
                webclient.webConnect(buttonId,index);
                listView.currentIndex = index;
                listView.hButtonId = buttonId;
                listView.hSection = section;
            }
            menu:ContextMenu {
                closeOnActivation: true

                id:cMenu
                MenuItem {
                    text: qsTr("Edit")
                    onClicked: { setAction("edit");setIndex(parseInt(buttonId)); setListIndex(index); pageStack.push(Qt.resolvedUrl("SecondPage.qml"));

                    }
                }

                MenuItem {
                    text: qsTr("Copy")
                    onClicked: {
                        setListIndex(-1);
                        setAction("copy");
                        setIndex(parseInt(buttonId))
                        pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
                    }
                }
                MenuItem {
                    text: qsTr("Remove")
                    onClicked: {
                       showRemorseItem()

                    }
                }
            }
            Label {
                width:Theme.buttonWidthSmall
                text: buttonText
                color:listView.currentIndex === index ? Theme.primaryColor : Theme.secondaryColor
            }
            Label {
                x:parent.x + Theme.buttonWidthSmall
                y:parent.y
                text:status;
            }

        }

        section.property: "section"
        section.criteria: ViewSection.FullString
        section.delegate: sectionHeading

    }
    Connections {
        target: webclient
        onHttpDone:bIndicator.running=false;

    }
}
