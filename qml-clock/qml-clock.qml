import Qt 4.7

Rectangle {
    id: clock
    width: 360
    height: 360
    color: "lightgray"
    property int seconds
    property int minutes
    property int hours

    Rectangle {
        id: clock_face
        width: clock.width/2
        height: clock.height/2
        color: "black"
        radius: width/2
        anchors.centerIn: parent

        function update_time() {
            var date = new Date;
             hours = date.getHours()
             minutes = date.getMinutes()
             seconds = date.getSeconds();

        }

        Timer {
            triggeredOnStart: true
            interval: 1000;
            running: true
            repeat: true
            onTriggered: clock_face.update_time()
        }

        Rectangle {
            id: hour_hand
            width: 0.25 * clock_face.width
            height:  1
            radius:  1
            color: "green"
            x: clock_face.x
            y: clock_face.y
            transform: Rotation {
                id: hour_update
                angle: clock.hours * 30 - 90
            }
        }

        Rectangle {
            id: minute_hand
            width: 0.35 * clock_face.width
            height:  1
            radius:  1
            color: "green"
            x: clock_face.x
            y: clock_face.y
            transform: Rotation {
                id: minute_update
                angle: clock.minutes * 6 - 90
            }
        }

        Rectangle {
            id: second_hand
            width: 0.45 * clock_face.width
            height:  1
            radius:  1
            color: "red"
            x: clock_face.x
            y: clock_face.y
            rotation: 0
            transform: Rotation {
                id: second_update
                angle: clock.seconds * 6 - 90
            }
        }
    }
}
