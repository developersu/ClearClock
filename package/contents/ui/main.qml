/*
    SPDX-FileCopyrightText: 2022 qewer33
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import QtQuick.Layouts 1.12
import Qt5Compat.GraphicalEffects
import org.kde.plasma.plasma5support as Plasma5Support

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.ConfigurableBackground

    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()

    Plasma5Support.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: plasmoid.configuration.clockShowSeconds ? 1000 : 60000
        intervalAlignment: plasmoid.configuration.clockShowSeconds ? Plasma5Support.Types.NoAlignment : Plasma5Support.Types.AlignToMinute
    }

    FontLoader {
        id: fontOutfitBold
        source: "../fonts/Outfit-Bold.ttf"
    }

    FontLoader {
        id: fontPlayRegular
        source: "../fonts/Play-Regular.ttf"
    }

    FontLoader {
        id: fontCaveat
        source: "../fonts/Caveat-Bold.ttf"
    }

    fullRepresentation: ColumnLayout {
        anchors.fill: parent
        spacing: -20

        TextMetrics {
            id: textMetricsClockLabel
            font.family: clockLabel.font.family
            font.pixelSize: clockLabel.font.pixelSize
            font.bold: clockLabel.font.bold
            text: if (!plasmoid.configuration.clockShowSeconds) " 99:99 "
                  else " 99:99:99 "
        }

        TextMetrics {
            id: textMetricsDayLabel
            font.family: dayLabel.font.family
            font.pixelSize: dayLabel.font.pixelSize
            font.bold: dayLabel.font.bold
            text: " Wednesday "
        }

        Item {
            implicitWidth: Math.max(textMetricsClockLabel.width, textMetricsDayLabel.width)
            implicitHeight: Math.max(textMetricsClockLabel.height, textMetricsDayLabel.height)
            Layout.alignment: Qt.AlignHCenter

            Text {
                id: clockLabel
                anchors.centerIn: parent

                property var getTextFormat: {
                    var AMPM = plasmoid.configuration.clockUse24hFormat ? "" : " AP"
                    if (plasmoid.configuration.clockShowSeconds)
                        return Qt.formatTime(currentDateTime, "hh:mm:ss" + AMPM).split(".").join(plasmoid.configuration.clockSeparator)
                    else
                        return Qt.formatTime(currentDateTime, "hh:mm" + AMPM).split(".").join(plasmoid.configuration.clockSeparator)
                }

                text: getTextFormat

                color: plasmoid.configuration.clockFontColor
                font.family: if (plasmoid.configuration.clockFontFamily === "ccdefault") fontOutfitBold.name
                             else plasmoid.configuration.clockFontFamily
                font.bold: plasmoid.configuration.clockBoldText
                font.italic: plasmoid.configuration.clockItalicText
                font.pixelSize: plasmoid.configuration.clockFontSize

                layer.enabled: plasmoid.configuration.clockShadowEnabled
                layer.effect: DropShadow {
                    color: plasmoid.configuration.clockShadowColor
                    radius: plasmoid.configuration.clockShadowRadius
                    horizontalOffset: plasmoid.configuration.clockShadowXOffset
                    verticalOffset: plasmoid.configuration.clockShadowYOffset
                    samples: plasmoid.configuration.clockShadowRadius*2
                }
            }

            Text {
                id: dayLabel
                visible: plasmoid.configuration.showDayDisplay
                anchors.centerIn: parent

                text: currentDateTime.toLocaleString(Qt.locale(), "dddd")

                color: plasmoid.configuration.dayFontColor
                font.family: if (plasmoid.configuration.dayFontFamily === "ccdefault") fontCaveat.name
                             else plasmoid.configuration.dayFontFamily
                font.bold: plasmoid.configuration.dayBoldText
                font.italic: plasmoid.configuration.dayItalicText
                font.pixelSize: plasmoid.configuration.dayFontSize

                layer.enabled: plasmoid.configuration.dayShadowEnabled
                layer.effect: DropShadow {
                    color: plasmoid.configuration.dayShadowColor
                    radius: plasmoid.configuration.dayShadowRadius
                    horizontalOffset: plasmoid.configuration.dayShadowXOffset
                    verticalOffset: plasmoid.configuration.dayShadowYOffset
                    samples: plasmoid.configuration.dayShadowYOffset*2
                }
            }
        }

        Text {
            id: dateLabel
            visible: plasmoid.configuration.showDateDisplay
            Layout.alignment: Qt.AlignHCenter

            text: currentDateTime.toLocaleString(Qt.locale(), plasmoid.configuration.dateCustomDateFormat)

            color: plasmoid.configuration.dateFontColor
            font.family: if (plasmoid.configuration.dateFontFamily === "ccdefault") fontPlayRegular.name
                         else plasmoid.configuration.dateFontFamily
            font.bold: plasmoid.configuration.dateBoldText
            font.italic: plasmoid.configuration.dateItalicText
            font.pixelSize: plasmoid.configuration.dateFontSize
            font.capitalization: Font.AllUppercase
            font.letterSpacing: plasmoid.configuration.dateLetterSpacing

            layer.enabled: plasmoid.configuration.dateShadowEnabled
            layer.effect: DropShadow {
                color: plasmoid.configuration.dateShadowColor
                radius: plasmoid.configuration.dateShadowRadius
                horizontalOffset: plasmoid.configuration.dateShadowXOffset
                verticalOffset: plasmoid.configuration.dateShadowYOffset
                samples: plasmoid.configuration.dateShadowYOffset*2
            }
        }
    }
}
