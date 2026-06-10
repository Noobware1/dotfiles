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
import qs.Core

LazyLoader {
    id: root

    readonly property BarModel __model: BarModel {
        id: model
    }

    active: model.ready

    PanelWindow {
        id: bar

        Binding {
            target: WindowManager
            property: "barWindow"
            value: bar
        }

        property bool isTop: model.direction == BarDirection.Top
        property bool isBottom: model.direction == BarDirection.Bottom
        property bool isRight: model.direction == BarDirection.Right
        property bool isLeft: model.direction == BarDirection.Left

        readonly property int orientation: bar.isLeft || bar.isRight ? Qt.Vertical : Qt.Horizontal

        anchors {
            top: isTop || isRight || isLeft
            right: isRight || isTop || isBottom
            left: isLeft || isTop || isBottom
            bottom: isBottom || isRight || isLeft
        }

        focusable: true
        WlrLayershell.namespace: "quickshell:bar"

        readonly property font effectiveFont: {
            switch (model.size) {
            case BarSize.Large:
                return MaterialTheme.typography.titleMedium;
            case BarSize.Medium:
                return MaterialTheme.typography.labelLarge;
            case BarSize.Small:
            default:
                return MaterialTheme.typography.labelMedium;
            }
        }

        readonly property font effectiveEmphasisedFont: {
            switch (model.size) {
            case BarSize.Large:
                return MaterialTheme.emphasizedTypography.titleLarge;
            case BarSize.Medium:
            case BarSize.Small:
            default:
                return MaterialTheme.emphasizedTypography.labelLarge;
            }
        }

        readonly property real effectiveIconSize: {
            switch (model.size) {
            case BarSize.Large:
                return LayoutDefaults.iconSizeMedium;
            case BarSize.Medium:
            case BarSize.Small:
            default:
                return LayoutDefaults.iconSizeSmall;
            }
        }

        readonly property real effectiveButtonSize: {
            switch (model.size) {
            case BarSize.Large:
                return 32;
            case BarSize.Medium:
                return 28;
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
                return 45;
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

        readonly property real spacing: 12

        readonly property real effectivePadding: {
            switch (model.size) {
            case BarSize.Large:
                return 8;
            case BarSize.Medium:
                return 6;
            case BarSize.Small:
            default:
                return 4;
            }
        }

        readonly property real availableLength: (bar.orientation == Qt.Horizontal ? bar.implicitHeight : bar.implicitWidth) - bar.effectivePadding * 2

        Rectangle {
            id: background

            anchors.fill: parent

            color: MaterialTheme.colorScheme.surface

            property color contentColor: MaterialTheme.colorScheme.onSurface

            Workspaces {
                font: bar.effectiveFont
                orientation: bar.orientation
                x: horizontal ? bar.spacing : (parent.width - width) / 2
                y: horizontal ? (parent.height - height) / 2 : bar.spacing
                buttonSize: bar.effectiveButtonSize
                iconSize: bar.effectiveIconSize
                maximumLength: (horizontal ? clock.x : clock.y) - bar.spacing * 2
                availableLength: bar.availableLength
            }

            Clock {
                id: clock
                orientation: bar.orientation
                font: bar.effectiveEmphasisedFont
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                availableLength: bar.availableLength
                iconSize: bar.effectiveIconSize
            }

            QuickSettings {
                iconSize: bar.effectiveIconSize
                barDirection: model.direction
                orientation: bar.orientation
                verticalMargin: bar.verticalMargin
                horizontalMargin: bar.horizontalMargin
                x: horizontal ? parent.width - width - horizontalMargin : (parent.width - width) / 2
                y: horizontal ? (parent.height - height) / 2 : parent.height - height - horizontalMargin
                buttonHeight: bar.effectiveButtonSize
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
