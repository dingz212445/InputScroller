/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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

import QtQuick 2.0
import QtQuick.VirtualKeyboard 2.1

Item {

    property var innerFlickable
    property var outerFlickable
    property var inputItem: InputContext.priv.inputItem

    onInputItemChanged: {
        console.debug("onInputItemChanged")
        innerFlickable = null
        outerFlickable = null
        if (inputItem !== null) {
            var parent_ = inputItem.parent
            while (parent_) {
                if (parent_.maximumFlickVelocity) {
                    if (innerFlickable) {
                        outerFlickable = parent_
                        break
                    } else {
                        innerFlickable = parent_
                    }
                }
                parent_ = parent_.parent
            }
            delayedLoading.restart()
        }
        console.debug("innerFlic: ", innerFlickable)
        console.debug("outerFlic: ", outerFlickable)
    }

    function ensureVisible(flickable) {
        console.debug("ensureVisible")
        if (Qt.inputMethod.visible && inputItem && flickable && flickable.visible /* && flickable.interactive */) {

            var verticallyFlickable = (flickable.flickableDirection === Flickable.HorizontalAndVerticalFlick || flickable.flickableDirection === Flickable.VerticalFlick
                                       || (flickable.flickableDirection === Flickable.AutoFlickDirection && flickable.contentHeight > flickable.height))
            console.debug("verticalFlicable: ", verticallyFlickable)

            if (!verticallyFlickable || !inputItem.hasOwnProperty("cursorRectangle"))
                return

            var cursorRectangle = flickable.contentItem.mapFromItem(inputItem, inputItem.cursorRectangle.x, inputItem.cursorRectangle.y)

            var oldContentY = flickable.contentY
            if (verticallyFlickable) {
                var scrollMarginVertical = (flickable && flickable.scrollMarginVertical) ? flickable.scrollMarginVertical : 10
                console.debug("scrollMarginVertical: ", scrollMarginVertical)
                console.debug("cursorRectangle.y: ", cursorRectangle.y)
                console.debug("contentY: ", flickable.contentY)
                console.debug("flickable.height: ", flickable.height)
                console.debug("inputItem.cursorRectangle.height: ", inputItem.cursorRectangle.height)
                if (flickable.contentY < cursorRectangle.y  - scrollMarginVertical){
                    console.debug("if")
                    flickable.contentY = Math.max(0, cursorRectangle.y  - scrollMarginVertical)
                    console.debug(flickable.contentY)
                }
                else if (flickable.contentY + flickable.height <= cursorRectangle.y  + inputItem.cursorRectangle.height + scrollMarginVertical){
                    console.debug("else if")
                    flickable.contentY = Math.min(flickable.contentHeight - flickable.height, cursorRectangle.y + inputItem.cursorRectangle.height - flickable.height + scrollMarginVertical)
                    console.debug(flickable.contentY)
                }
                console.debug("none")
            }
        }else {
            flickable.contentY = 0
        }

        console.debug("------------------------------------------")
    }
    Timer {
        id: delayedLoading
        interval: 10
        onTriggered: {
            ensureVisible(innerFlickable)
            ensureVisible(outerFlickable)
        }
    }
    Connections {
        ignoreUnknownSignals: true
        target: Qt.inputMethod
        function onAnimatingChanged() { if (inputItem && !Qt.inputMethod.animating) delayedLoading.restart() }
        function onKeyboardRectangleChanged() { if (inputItem) delayedLoading.restart() }
        function onCursorRectangleChanged() { if (inputItem && inputItem.activeFocus) delayedLoading.restart() }
    }
}
