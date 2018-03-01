/* GCompris - binary_bulb.qml
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

import "../../core"
import "binary_bulb.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "resource/background.svg"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias bulbs: bulbs
            property int sum: 0
            property int num: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        IntroMessage {
            id: message
            onIntroDone: {
                Activity.initLevel()
            }
            intro: [
                qsTr("Computers use Binary number system, where there are two symbols, 0 and 1."),
                qsTr("In decimal number system 123 is represented as 1 x 100 + 2 x 10 + 3 x 1"),
                qsTr("Binary represents numbers in the same pattern, but using powers of 2 instead of powers of 10 that decimal uses"),
                qsTr("So, 1 in binary is represented by 001, 4 by 100, 7 by 111 and so on.."),
                qsTr("Our computer has many many switches (called transistors) that can be turned on or off given electricity, and a switch that is on will represent a 1 and a switch that is off will represent a 0."),
                qsTr("In this activity, you are given a number, you have to find its binary representation by turning on the bulbs. An on bulb representes 1 and an off bulb represents 0")
            ]
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }               
        }   

        GCText {
            id: question
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            fontSize: largeSize
            width: parent.width * 0.9
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"
            text: qsTr("What is the binary representation of " + items.num)
            opacity: 1.0
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 20

            Repeater {
                id: bulbs
                model: 8
                LightBulb {
                }
            }
        }

        IntroButton {
            id: reachedSofar
            width: parent.width / 8
            height: 90
            z: 5
            anchors.left: row.left
            anchors.leftMargin: 15
            anchors.top: row.bottom
            anchors.topMargin: 25
            text: String(items.sum)
        }

        IntroButton {
            id: done
            width: parent.width / 8
            height: 90
            z: 5
            anchors.right: row.right
            anchors.topMargin: 25
            anchors.rightMargin: 15
            anchors.top: row.bottom
            text: qsTr("Done")
            onClicked: {
                if(items.sum == items.num) {
                    bonus.good("lion");
                    Activity.resetBulbs();
                }           
                else {
                    bonus.bad("lion");
                    Activity.resetBulbs();
                    items.sum = 0
                }
            }
        }
    }
}