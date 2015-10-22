import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.4


Rectangle {
    width: 400
    height: 600
    color: "black"

    property int page_width: width

    Image{
        source: "images/underground.jpg"
        width: parent.width * 1.5
        height: parent.height
        opacity: 0.7
    }

    TextField{
        id: chat_textfield
        width: parent.width
        height: main.items_height
        anchors.bottom: parent.bottom
        font.family: digital_font.name
        style: TextFieldStyle {
           textColor: "white"
           background: Rectangle {
               color: "black"
               radius: 2
               border.color: "grey"
               border.width: 3
           }//rectangle
        }//style
        Keys.onReturnPressed: {
            console.debug(" pressed")
            if(text!=""){
                chat_network.addParam("text", text)
                chat_network.addParam("name", main.name)
                chat_network.sendPostRequest(main.host+"chat")
                text=""
            }
        }//onReturnPressed
        onTextChanged: {
            typing_sound.play()
            console.debug("play")
        }
    }

    Component{
        id: chat_dele
        Text{
            text:chat_name + ": "+ chat_text
            color: main.font_color
            font.family: digital_font.name
            wrapMode: Text.Wrap
            width: page_width
        }
    }

    ListModel{
        id: chat_model
    }

    ListView{
        width: parent.width
        height: parent.height - chat_textfield.height
        anchors.top: parent.top
        model: chat_model
        delegate: chat_dele
    }

    Network{
        id: chat_network
        anchors.fill: parent
        onNetworkReply: {
            var i
            var j = JSON.parse(network_reply_string);
            if(j["status"]==true){
                chat_model.clear()
                console.debug("chat: "+j["chat"])
                console.debug("num of chat:  "+j["chat"].length)
                for(i=0;i<j["chat"].length;i++){
                    console.debug("chat: "+j["chat"][i].text)
                    chat_model.append({"chat_text": j["chat"][i].text,
                                      "chat_name": j["chat"][i].name,
                                      "chat_sent_on": j["chat"][i].sent_on})
                }
            }
            else{
                console.debug("Server Error")
            }
        }
    }

    onVisibleChanged: {
        if(visible){
            chat_network.sendPostRequest(main.host+"get_chat")
        }
    }

}

