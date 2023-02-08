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
                    vol=MUTE
            ;;
    esac
    notify-send -a "volume.sh" -r "9993" -h int:value:"$vol" -i "$icon" -t 1000 "Volume: $vol" "$sink"
}

function send_line_notif() {
    iconpath="$HOME/.local/share/icons/volume"
    mute=$(pactl get-source-mute $line)

    case $mute in
        *no)        icon="$iconpath/295-volume-high-white.png"
                    body="Line-in unmuted"
            ;;
        *yes)       icon="$iconpath/299-volume-mute2-white.png"
                    body="Line-in muted"
            ;;
    esac
    notify-send -a "volume.sh" -r "9994" -i "$icon" -t 1000 "$body"
}

function mute_pfw() {
    pid=$(xdotool getwindowfocus getwindowpid)
    index=$(pactl list sink-inputs | awk '
        /^Sink Input #[0-9]+$/ {
            sub("#", "", $3)
            x=$3
        }
        /application.process.id = "'$pid'"/ {
            print x
        }')
    pactl set-sink-input-mute $index toggle
    mute_pfw_notif $index $pid
}

function mute_pfw_notif() {
    mute=$(pactl -f json list sink-inputs | jq -r ".[] | select(.index == $1).mute")
    iconpath="$HOME/.local/share/icons/volume"
    title=$(xtitle $(pfw))

    case $mute in
        *false)     icon="$iconpath/295-volume-high-white.png"
                    body="$title unmuted"
            ;;
        *true)      icon="$iconpath/299-volume-mute2-white.png"
                    body="$title muted"
            ;;
    esac
    notify-send -a "volume.sh" -r "9995" -i "$icon" -t 1000 "$body"
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
        send_notification
        ;;
    line)
        line="alsa_input.pci-0000_0a_00.3.analog-stereo"
        pactl set-source-mute $line toggle
        send_line_notif $line
        ;;
    pfw)
        mute_pfw
        ;;
    *)
        send_notification
esac
