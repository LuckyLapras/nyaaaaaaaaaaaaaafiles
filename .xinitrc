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

xrdb -merge $userresources
setxkbmap gb

# i miss my scroll wheel
xinput set-prop 'PixArt USB Optical Mouse' 'libinput Scroll Method Enabled' 0 0 1

wms="    i3, hypr/Hypr, awesome, gnome, mutter"

case $1 in
    i3) exec i3 ;;
    hypr|Hypr)    exec hyprlily ;;
    awesome) exec awesome >/tmp/awesomelog 2>&1 ;;
    gnome) export XDG_SESSION_TYPE=x11
        GDK_BACKEND=x11
        exec gnome-session
        ;;
    mutter) exec mutter ;;
    bspwm) exec bspwm ;;
        *) printf "Please choose one of\n$wms"
esac
