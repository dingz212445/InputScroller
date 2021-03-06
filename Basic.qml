/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Virtual Keyboard module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.VirtualKeyboard 2.1

Rectangle {
    width: 1280
    height: 720
    color: "red"

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: parent.height
        interactive: false
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: textEditors
            spacing: 15
            x: 12
            y: 12
            width: parent.width - 26

            Label {
                color: "#565758"
                text: "Tap fields to enter text"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 22
            }
            TextField {
                width: parent.width
                placeholderText: "One line field"
                onAccepted: passwordField.focus = true
            }
            TextField {
                id: passwordField
                width: parent.width
                echoMode: TextInput.Password
                placeholderText: "Password field"
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                onAccepted: upperCaseField.focus = true
            }
            TextField {
                id: upperCaseField
                width: parent.width
                placeholderText: "Upper case field"
                inputMethodHints: Qt.ImhUppercaseOnly
                onAccepted: lowerCaseField.focus = true
            }
            TextField {
                id: lowerCaseField
                width: parent.width
                placeholderText: "Lower case field"
                inputMethodHints: Qt.ImhLowercaseOnly
                onAccepted: phoneNumberField.focus = true
            }
            TextField {
                id: phoneNumberField
                validator: RegExpValidator { regExp: /^[0-9\+\-\#\*\ ]{6,}$/ }
                width: parent.width
                placeholderText: "Phone number field"
                inputMethodHints: Qt.ImhDialableCharactersOnly
                onAccepted: formattedNumberField.focus = true
            }
            TextField {
                id: formattedNumberField
                width: parent.width
                placeholderText: "Formatted number field"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onAccepted: digitsField.focus = true
            }
            TextField {
                id: digitsField
                width: parent.width
                placeholderText: "Digits only field"
                inputMethodHints: Qt.ImhDigitsOnly
                onAccepted: textArea.focus = true
            }
            TextArea {
                id: textArea
                width: parent.width
                placeholderText: "Multiple line field"
                height: Math.max(206, implicitHeight)
            }
        }
    }
}

