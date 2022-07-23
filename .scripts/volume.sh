#!/bin/bash

function send_notification() {
    iconpath="$HOME/.local/share/icons/volume"
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/.$//')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@)
    sink=$(pactl list sinks | sed -n '/State: RUNNING/,$p' | sed \$d | grep -e "device.description" | cut -f2 -d\")

    case $vol in
        100|[6-9]?) icon="$iconpath/295-volume-high-white.png"
            ;;
        [3-5]?)     icon="$iconpath/296-volume-medium-white.png"
            ;;
        [1-2]?)     icon="$iconpath/297-volume-low-white.png"
            ;;
        *)          icon="$iconpath/298-volume-mute-white.png"
            ;;
    esac

    case $mute in
        *yes)       icon="$iconpath/299-volume-mute2-white.png"
            ;;
    esac
    dunstify -a "changevolume" -r "9993" -h int:value:"$vol" -i "$icon" -t 1000 "Volume: $vol" "$sink"
}

case $1 in
    up)
        # Set the volume on (if it was muted)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        send_notification
        ;;
    down)
        # Set the volume on (if it was muted)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        send_notification
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        mute=$(pactl get-sink-mute @DEFAULT_SINK@)
        case $mute in
            *yes) ;;
            *no)  ;;
        esac
        send_notification
        ;;
esac
