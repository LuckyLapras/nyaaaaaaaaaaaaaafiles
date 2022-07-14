#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xset -dpms
xset s off

xrdb -merge ~/.Xresources
setxkbmap gb
case $1 in
    i3)      exec i3 ;;
    hypr|Hypr)    exec Hypr ;;
    awesome) exec awesome ;;
esac
