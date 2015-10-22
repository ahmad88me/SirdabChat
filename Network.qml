import QtQuick 2.0
import Networking 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2

Item {
    width: 100
    height: 62
    id: network
    property alias token: networkcommmain.token


    function addParam(key,val){
        networkcommmain.addParam(key,val)
    }

    function addImage(key,val){
        networkcommmain.addImage(key,val)
    }

    function addFile(key,val,file_extension, file_type){
        networkcommmain.addFile(key,val, file_extension, file_type)
    }

    function sendPostRequest(target_url){
        networkcommmain.sendPostRequest(target_url)
    }

    signal networkSend()
    signal networkReply(string network_reply_string)



    Component.onCompleted: {
        networkcommmain.networkSend.connect(network.networkSend)
        networkcommmain.networkReply.connect(network.networkReply)

    }

    BusyIndicator {
        id: busy_indicator
        running: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        //width: parent.width/2
        //height: parent.height/2
    }

    MouseArea{
        anchors.fill: parent
        visible: busy_indicator.running
        onClicked: {
            console.debug("cannot click while loading")
        }
    }

    MessageDialog{
        id: message_dialog
        title: "Error"
        text:""
        visible: false
    }

    Networkcomm{
        id: networkcommmain
        onNetworkReply:{
            console.debug("network reply")
            busy_indicator.running=false
            if(network_reply_string==""){
                message_dialog.text="Check you internet connection"
                message_dialog.visible=true
            }
            else{
                var j = JSON.parse(network_reply_string);
                if (j["status"] == false){
                    message_dialog.text = j["error"]
                }
            }
        }
        onNetworkSend: {
            busy_indicator.running=true
            console.debug("network send")
        }
    }
}

