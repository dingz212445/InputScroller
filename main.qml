import QtQuick 2.15
import QtQml 2.14
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import "content"

Window {
    id: window
    width: 1000
    height: 600
    visible: true
    title: qsTr("Hello World")

    Item {
        anchors.fill: parent
        Basic {
            id: virtualKeyboard
            anchors.fill: parent
        }

        InputPanel {
            id: inputPanel
            z: 89
            y: yPositionWhenHidden
            width: parent.width

            property real yPositionWhenHidden: parent.height

            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: inputPanel.yPositionWhenHidden - inputPanel.height
                }
            }
            transitions: Transition {
                id: inputPanelTransition
                from: ""
                to: "visible"
                reversible: true
                enabled: !VirtualKeyboardSettings.fullScreenMode
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            Binding {
                target: InputContext
                property: "animating"
                value: inputPanelTransition.running
                restoreMode: Binding.RestoreBinding
            }
            AutoScroller {}
        }
    }
}

