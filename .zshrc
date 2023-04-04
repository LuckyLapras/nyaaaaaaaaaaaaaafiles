#source ~/src/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /home/lily/src/zsh-autosuggestions/zsh-autosuggestions.zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lily/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=/home/lily/.local/bin:$PATH

# Aliases
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias grep='grep --color=auto'
alias grubup="sudo update-grub"
alias hw='hwinfo --short'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias psmem='ps auxf | sort -nr -k 4'
alias rmpkg="sudo pacman -Rdd"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias upd='/usr/bin/update'
alias vdir='vdir --color=auto'
alias wget='wget -c '

# Help people new to Arch
alias apt-get='man pacman'
alias apt='man pacman'
alias helpme='cht.sh --shell'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns `pacman -Qtdq`'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

alias config='/usr/bin/git --git-dir=/home/lily/.git/ --work-tree=/home/lily'

alias wine32='WINEPREFIX=~/.wine32 wine'

notes() { vim "/home/lily/.notes/$@"; }
backup() { cp "$@" "$@.bak" }
dunzip() {
    if unzip -l "$1" | sed -n 5p | grep '/' &> /dev/null
    then
        unzip "$1"
    else
        unzip "$1" -d "${1%.zip}"
    fi
}

# ls
alias ls='ls -a --color=auto'
alias ll='ls -alh --color=auto'
alias ld='ls -dlh .* --color=auto'
alias lf='ls -ApL --color=always | grep --color=always -v /'

alias 3dsntr='sudo create_ap wlp6s0 enp7s0 3DSNTR NozoEli6969'

preexec() {
    cmd_start_date=$(date +%s)
    cmd_name=$1
    if [[ -n $DISPLAY ]];
    then
        org_win=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
    fi
}

precmd() {
    cmd_status=$?
    if [[ -n $DISPLAY ]];
    then
        case $TERM in
            st*)    printf '\033];%s\a' "${PWD/$HOME/~} - $(pstree -sA $$ | awk -F "---" '{ print $2 }')"
                ;;
            xterm*) printf "\e]0;${PWD/$HOME/~} - $(pstree -sA $$ | awk -F "---" '{ print $(NF-2) }' 2>/dev/null)"
                ;;
        esac

        if [[ -n $cmd_start_date ]];
        then
            cur_win=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
            case $cur_win in
                $org_win) :
                    ;;
                *)  cmd_end_date=$(date +%s)
                    cmd_elapsed=$(($cmd_end_date - $cmd_start_date))
                    elapsed_read=$(date -u -d @${cmd_elapsed} +"%T")
                    cmd_notify_thresh=60

                    if [[ $cmd_elapsed -gt $cmd_notify_thresh ]];
                    then
                        notify-send -a 'zsh' -u critical 'Command finished!' "\"$cmd_name\" has finished executing after $elapsed_read with status $cmd_status."
                    fi
            esac
        fi
    fi
}


setopt CORRECT

source /home/lily/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/src/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /usr/share/nvm/init-nvm.sh
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
