pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import Material3
import qs.Features.Bar.Components
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.Clock
import qs.Features.Bar.Workspaces
import qs.Features.Bar.Models

LazyLoader {
    id: root

    readonly property BarModel __model: BarModel {
        id: model
    }

    active: model.ready

    PanelWindow {
        id: bar

        property bool isTop: model.direction == BarDirection.Top
        property bool isBottom: model.direction == BarDirection.Bottom
        property bool isRight: model.direction == BarDirection.Right
        property bool isLeft: model.direction == BarDirection.Left

        anchors {
            top: isTop || isRight || isLeft
            right: isRight || isTop || isBottom
            left: isLeft || isTop || isBottom
            bottom: isBottom || isRight || isLeft
        }

        focusable: true
        WlrLayershell.namespace: "quickshell:bar"

        readonly property font font: {
            switch (model.size) {
            case BarSize.Large:
                return MaterialTheme.typography.labelLarge;
            case BarSize.Medium:
                return MaterialTheme.typography.labelMedium;
            case BarSize.Small:
            default:
                return MaterialTheme.typography.labelSmall;
            }
        }

        readonly property real iconSize: {
            switch (model.size) {
            case BarSize.Large:
                return 34;
            case BarSize.Medium:
                return 24;
            case BarSize.Small:
            default:
                return 20;
            }
        }
        readonly property real barSize: {
            switch (model.size) {
            case BarSize.Large:
                return 60;
            case BarSize.Medium:
                return 40;
            case BarSize.Small:
            default:
                return 30;
            }
        }

        implicitHeight: isTop || isBottom ? barSize : 0
        implicitWidth: isLeft || isRight ? barSize : 0

        color: "transparent"

        readonly property alias backgroundColor: background.color
        readonly property real horizontalMargin: 10
        readonly property real verticalMargin: 5
        readonly property real heightWithMargin: bar.implicitHeight - (bar.verticalMargin * 2)

        Rectangle {
            id: background
            height: bar.implicitHeight

            anchors.fill: parent

            color: MaterialTheme.colorScheme.surface

            property color contentColor: MaterialTheme.colorScheme.onSurface

            Workspaces {
                height: bar.heightWithMargin
                anchors.left: parent.left
                anchors.leftMargin: bar.horizontalMargin
                anchors.verticalCenter: parent.verticalCenter
                font: bar.font
            }

            Clock {
                anchors.centerIn: parent
                height: bar.heightWithMargin
            }

            QuickSettings {
                anchors.right: parent.right
                anchors.rightMargin: bar.horizontalMargin * 2
                height: bar.heightWithMargin
                anchors.verticalCenter: parent.verticalCenter
                iconSize: bar.iconSize
                window: bar
            }
        }

        LazyLoader {
            active: model.roundedCorners
            PanelWindow {
                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.namespace: "quickshell:roundCorner"
                WlrLayershell.layer: WlrLayer.Background
                color: "transparent"

                anchors {
                    top: bar.anchors.top
                    right: bar.anchors.right
                    left: bar.anchors.left
                    bottom: bar.anchors.bottom
                }

                margins {
                    top: bar.isTop ? bar.implicitHeight : 0
                    left: bar.isLeft ? bar.implicitWidth : 0
                    bottom: bar.isBottom ? bar.implicitHeight : 0
                    right: bar.isRight ? bar.implicitWidth : 0
                }

                implicitHeight: bar.implicitHeight
                implicitWidth: bar.implicitWidth

                RoundCorner {
                    size: bar.barSize
                    anchors {
                        top: bar.isTop || bar.isLeft || bar.isRight ? parent.top : undefined
                        bottom: bar.isBottom ? parent.bottom : undefined
                    }

                    corner: switch (model.direction) {
                    case BarDirection.Left:
                        return Qt.TopLeftCorner;
                    case BarDirection.Right:
                        return Qt.TopRightCorner;
                    case BarDirection.Bottom:
                        return Qt.BottomLeftCorner;
                    case BarDirection.Top:
                    default:
                        return Qt.TopLeftCorner;
                    }
                    color: bar.backgroundColor
                }

                RoundCorner {
                    anchors {
                        right: bar.isTop || bar.isBottom ? parent.right : undefined
                        bottom: bar.isLeft || bar.isRight ? parent.bottom : undefined
                        top: bar.isTop ? parent.top : undefined
                    }
                    size: bar.barSize
                    corner: switch (model.direction) {
                    case BarDirection.Left:
                        return Qt.BottomLeftCorner;
                    case BarDirection.Right:
                        return Qt.BottomRightCorner;
                    case BarDirection.Bottom:
                        return Qt.BottomRightCorner;
                    case BarDirection.Top:
                    default:
                        return Qt.TopRightCorner;
                    }

                    color: bar.backgroundColor
                }
            }
        }
    }
}
