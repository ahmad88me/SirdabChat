import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtMultimedia 5.5


ApplicationWindow {
    title: qsTr("Sirdab Chat")
    width: 400
    height: 600
    visible: true
    id: main

    property string name: ""
    property string host: "http://54.88.191.135/qttraining/"
    property int items_height : 50
    property string font_color: "#33FF33"

    LoginPage{
        id: login_page
        anchors.fill: parent
        visible: true
    }

    ChatPage{
        id: chat_page
        anchors.fill: parent
        visible: false
    }

    FontLoader{
        id: digital_font
        source: "fonts/DS-DIGIB.TTF"//"fonts/digital-7.ttf"
    }

    SoundEffect {
        id: typing_sound
        source: "sounds/typewriter-key.wav"
    }

}
