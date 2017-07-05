import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All
    SilicaWebView {
        header:PageHeader {
            title: qsTr("Output")
        }
        id: webView
        objectName:"webViewObj"
        anchors.fill: parent

   }
}

