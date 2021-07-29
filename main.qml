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
            x: Screen.orientation === Qt.LandscapeOrientation ? 0 : (parent.width-parent.height) / 2
            width: Screen.orientation === Qt.LandscapeOrientation ? parent.width : parent.height

            //keyboard.shadowInputControl.height: (Screen.orientation === Qt.LandscapeOrientation ? parent.height : parent.width) - keyboard.height

            property real yPositionWhenHidden: Screen.orientation === Qt.LandscapeOrientation ? parent.height : parent.width + (parent.height-parent.width) / 2

            states: State {
                name: "visible"
                /*  The visibility of the InputPanel can be bound to the Qt.inputMethod.visible property,
                        but then the handwriting input panel and the keyboard input panel can be visible
                        at the same time. Here the visibility is bound to InputPanel.active property instead,
                        which allows the handwriting panel to control the visibility when necessary.
                    */
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

