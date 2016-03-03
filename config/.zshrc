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

# TODO enable git plugin
#source /home/d/oldfiles/.oh-my-zsh/plugins/git/git.plugin.zsh

alias mydf="df -hPT | column -t"
alias ll="ls -lah"
#alias rm="rm -i"
alias cp="cp -i"
alias ls="ls --color=auto"
alias l="ls -ail"
alias cl="clear"
alias astyle="astyle --options=/etc/astyle.conf"
alias links="links https://google.com"
alias df="pydf -h"
alias reboot="shutdown -r now"
alias feh="feh -."
alias py=python
alias bpy=bpython
alias py2=python2
alias py3=python3
alias asc="feh -. ascii-image"
alias grep="grep --color=auto"
alias asct="vim ascii-text"
alias pb="xclip -selection primary"
alias cb="xclip -selection clipboard"
alias cal="cal -m"
alias R="R --quiet"
alias promises="watch -n 1 promise list_undone"
#alias startx="startx -- vt$(echo $TTY | sed -r 's/.*tty(.*).*/\1/g')"

alias -s jar="java -jar"
alias -s jpg="feh -."
alias -s png="feh -."

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

#environement variables
setopt CORRECT
setopt ALWAYS_TO_END
setopt NOTIFY
setopt NOBEEP
setopt AUTOLIST
setopt AUTOCD
setopt PRINT_EIGHT_BIT
#setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# for have colors
autoload -U colors
colors

# define your colors here (i hate white background)
host_color="green" 
path_color="blue"
date_color="white"
text_color="white"
err_color="red"
prompt_color="yellow"


#PROMPT="%m %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . %{${fg[red]}%}%? )%{${fg[blue]}%}»%{${reset_color}%} "
#PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
#host="%{$fg[$host_color]%}%n@%m"
#cpath="%B%{$fg[$path_color]%}%/%b"
#end="%{$reset_color%}%% "

host="%B%{$fg[$host_color]%}%n"
cpath="%B%{$fg[$path_color]%}%c%b"
#end="%(?..%{$fg[$err_color]%}%? )%B%{$fg[$prompt_color]%}%#%{$fg[$text_color]%}"
end="%(?..%{$fg[$err_color]%}%? )%B%{$fg[$prompt_color]%}%#%{$reset_color%}"

PS1="$host $cpath $end "

HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="mm/dd/yyyy"

PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vmware/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.9.3:~/.gem/ruby/2.3.0/bin:/home/local/usr/bin/:~/go/bin"
PATH="$PATH:$HOME/Binary:/opt/vmware/bin"
export GOPATH=~/go
