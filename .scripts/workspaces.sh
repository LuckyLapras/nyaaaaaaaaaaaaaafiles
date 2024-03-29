#!/bin/bash

function workspaces() {
    all=$(wmctrl -d)
    occ=$(wmctrl -l | awk '{print $2}' | tr '\n' ' ')

    NID=6969

    string=''
    while read line
    do
        num=${line:0:1}
        name=${line: -1}
        cur=${line:3:1}

        ws=$name

        if ! [[ "$occ" == *"$num"* ]]
        then
            ws='|'
        fi

        case $cur in
            '*') ws=$cur
                ;;
        esac

        ws_string="$ws_string $ws"
    done <<< $all
    }

function title() {
    title=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) WM_NAME |
        sed -nr 's/.*= "(.*)"$/\1/p')
    if ! [[ "$title" == "Eww"* ]]
    then
        body="Current Window: $title"
    else
        exit 1
    fi
    }

function new_win() {
    body="${@:2} opened on Workspace $1"
}

workspaces

case $1 in
    new_win) new_win ${@:2}
        ;;
    *) title
esac

notify-send -a "workspaces.sh" -t 1000 -r $NID "$ws_string" "$body"
