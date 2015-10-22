import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtMultimedia 5.5

Rectangle {
    width: 400
    height: 600

    property int page_height: height

    Image{
        source: "images/underground.jpg"
        width: parent.width * 1.5
        height: parent.height
    }

    Rectangle{
        color: "black"
        anchors.fill: parent
        opacity: 0.1
    }

    Rectangle{
        id: login_rec
        color: "black"
        opacity: 0.7
        width: parent.width* 0.5
        height: width*0.7
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            text: "Enter your code"
            color: main.font_color
            font.family: digital_font.name
            anchors.bottom: login_text_field.top
        }


        TextField{
            id: login_text_field
            font.family: digital_font.name
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Keys.onReturnPressed: {
                if(text!=""){
                    main.name = text
                    chat_page.visible=true
                    login_page.visible=false
                }
            }
            onTextChanged: {
                typing_sound.play()
            }
        }
    }

    SequentialAnimation{
        id: login_animation
        running: false
        SpringAnimation{
            id: login_animation_y
            target: login_rec; property: "y"; to: page_height*0.4  - login_rec.height/2
            spring: 4; epsilon: 0.25; damping: 0.08
        }
    }

    Audio {
         id: playSound
         source: "sounds/gate.mp3"
     }

    Timer{
        id: sound_timer
        interval: 15000
        repeat: false
        onTriggered: {
            playSound.stop()
            console.debug("stopped")
        }
    }
    
    Component.onCompleted: {
        playSound.play()
        login_animation.running=true
        sound_timer.start()
    }

}

