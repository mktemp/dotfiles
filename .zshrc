# 
# This file is based on the configuration written by
# Bruno Bonfils, <asyd@debian-fr.org> 
# Written since summer 2001

# colors
#eval `dircolors /etc/DIR_COLORS`

fpath=(~/.zsh/completion $fpath)

autoload -U zutil
autoload -U compinit
autoload -U complist

autoload -Uz select-word-style
select-word-style bash
bindkey -e
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey '^K' kill-whole-line
bindkey "\e[H" beginning-of-line        # Home (xorg)
bindkey "\e[1~" beginning-of-line       # Home (console)
bindkey "\e[4~" end-of-line             # End (console)
bindkey "\e[F" end-of-line              # End (xorg)
bindkey "\e[2~" overwrite-mode          # Ins
bindkey "\e[3~" delete-char             # Delete
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Activation
compinit

alias mydf="df -hPT | column -t"
alias l="ls -ail"
alias ll="ls -lah"
alias rm="rm -I"
alias cp="cp -i"
alias ls="ls --color=auto"
links() {
    command links $(if [[ -z "$@" ]]; then echo https://google.com; else echo "$@"; fi)
}
alias df="pydf -h"
alias reboot="shutdown -r now"
alias feh="feh -."
alias py="python"
alias py2="python2"
alias py3="python3"
alias ipy="ipython --pprint --no-banner --autoedit-syntax --no-confirm-exit"
alias ipy2="ipython2 --pprint --no-banner --autoedit-syntax --no-confirm-exit"
alias ipy3="ipython3 --pprint --no-banner --autoedit-syntax --no-confirm-exit"
alias bpy="bpython"
alias grep="grep --color=auto"
alias pb="xclip -selection primary"
alias cb="xclip -selection clipboard"
alias cal="cal -m"
alias R="R --quiet"
alias nbook="jupyter-notebook"
upgrd() {
    tmpfile=$(mktemp)
    yaourt -Su 1>&1 1>$tmpfile
    upgraded=$(cat $tmpfile | grep upgrading | tail -n 1 | cut -d / -f 1 | cut -d '(' -f 2)
    if [[ -z $upgraded ]] return
    difference=$(( $_to_be_upgraded - $upgraded ))
    if [[ 0 -lt $difference ]]; then
        echo $difference > /usr/local/share/sysautoupdate/count
    else
        echo > /usr/local/share/sysautoupdate/count
    fi
}

# do a du -hs on each dir on current path
alias lsdir="for dir in *;do;if [ -d \$dir ];then;du -hsL \$dir;fi;done"

# case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# process completion
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# zstyle
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{yellow}%d%f%u'
zstyle ':completion:*' rehash true  # EXPENSIVE

# environement variables
setopt CORRECT
setopt ALWAYS_TO_END
setopt NOTIFY
setopt NOBEEP
setopt AUTOLIST
setopt AUTOCD
setopt PRINT_EIGHT_BIT
setopt HIST_IGNORE_ALL_DUPS
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

## PROMPT
# git info
git_branch() { 
    br=$(git branch 2>/dev/null | grep '^\*' | cut -d ' ' -f 2)
    if [[ -n "$br" ]] echo -n ":$br"
}
git_number_of_unpushed_commits() { 
    (echo -n '+'; git log --branches --not --remotes 2>/dev/null | grep ^commit | wc -l) | grep -v '^+0$'
}
git_any_modifications() { 
    if [[ -n "$(git diff 2>/dev/null)" ]]; then
        echo '\e[31m*'  # red
    elif [[ -n "$(git diff $(tmp=$(git_branch); echo ${tmp:1}) 2>/dev/null)" ]]; then
        echo '\e[37m*'  # black
    fi
}

# enable colors
autoload -U colors
colors

# specify color scheme
host_color="green" 
path_color="blue"
date_color="white"
text_color="white"
err_color="red"
prompt_color="yellow"

host="%B%{$fg[$host_color]%}%n"
cpath="%B%{$fg[$path_color]%}%c%b"
setopt promptsubst
git_info='%B%{$fg[black]%}$(git_branch)%{$fg[cyan]%}$(git_number_of_unpushed_commits)$(git_any_modifications)'  # EXPENSIVE
end="%(?..%{$fg[$err_color]%}%? )%B%{$fg[$prompt_color]%}%#%{$reset_color%}%b"

PS1="$host $cpath$git_info $end "


HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="mm/dd/yyyy"

# FIXME should be refactored
PATH="$PATH\
:/usr/local/sbin\
:/usr/local/bin\
:/usr/sbin\
:/usr/bin\
:/sbin\
:/bin\
:/opt/vmware/bin\
:/usr/x86_64-pc-linux-gnu/gcc-bin/4.9.3\
:~/.gem/ruby/2.3.0/bin\
:/home/local/usr/bin/\
:$HOME/go/bin\
:.\
:$HOME/repos/metasploit-framework\
"

# TODO
# 0. Clear the whole structure
# 1. Prompt color resetting
# 2. Git branch and a star if there are any changes
# 4. Clear $PATH
# 5. Look for some life improving tips
# 6. Don't remove whitespace before the pipeline sign
# 7. Suggestions based on the whole left string, not the first word only
# 8. Make ^W removing non-letter characters if there're no more letters in the string
# 9. Cross-language correction

tmux attach -t base 2>/dev/null || tmux new -s base 2>/dev/null || true

_to_be_upgraded=$(cat /usr/local/share/sysautoupdate/count)
if [[ -n "$_to_be_upgraded" ]]; then
    if [[ 1 -lt "$_to_be_upgraded" ]]; then
        echo "\e[1m"$_to_be_upgraded"\e[m" packages are available for upgrade
    else
        echo "\e[1m"$_to_be_upgraded"\e[m" package is available for upgrade
    fi
fi
