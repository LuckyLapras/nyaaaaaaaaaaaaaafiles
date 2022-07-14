#
# ~/.bash_profile
#

[[ -f ~/.zshrc ]] && . ~/.zshrc

export EDITOR=vim

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]];
then
    startx ~/.xinitrc i3
    #Hyprland
fi
