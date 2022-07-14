#!/bin/bash

t=0

toggle() {
    t=$(((t + 1) % 2))
}


trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        d=$(date '+%H:%M %d/%m/%y')
        echo $d 
    else
        d=$(date '+%d/%m/%y')
        echo  $d 
    fi
    sleep 1 &
    wait
done
