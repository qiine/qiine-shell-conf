
# bashrc


# Stop loading .bashrc in non interactive mode (safer)
[[ $- == *i* ]] || return

source -- "$(blesh-share)"/ble.sh --attach=none

## [History]
#----------------------------------------------------------------------
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# Alias
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# # enable programmable completion features (you don't need to enable
# # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# # sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#   elif [ -f /etc/bash_completion ]; then
#     . /etc/bash_completion
#   fi
# fi


#######################################################################
# Begin user conf #
#######################################################################

export VISUAL=nvim
export EDITOR=nvim
export SUDO_EDITOR=nvim
# export PAGER=nvim
export MANPAGER="nvim +Man!"
# export MANWIDTH=999

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/pnpm/bin:$PATH"
export PATH="$HOME/.luarocks/bin:$PATH"

# bash func
[[ -r "$HOME/Personal/dotfiles/User/Shell/Bash/functions.sh" ]] &&
    source "$HOME/Personal/dotfiles/User/Shell/Bash/functions.sh"


eval "$(direnv hook bash)"

# Starship prompt
eval "$(starship init bash)"




# [[ -r "$HOME/Personal/dotfiles/User/Shell/Bash/fzf-bash-completion.sh" ]] &&
#    source "$HOME/Personal/dotfiles/User/Shell/Bash/fzf-bash-completion.sh"

# bind -x '"\t": fzf_bash_completion'

# export CARAPACE_BRIDGES='bash'
export CARAPACE_BRIDGES='ash/sync'
source <(carapace _carapace)

#pseudo vi mode
# set -o vi


# Control newline wrapping
# stty -onlcr


## [keymaps]
#----------------------------------------------------------------------
bind '"\x08": backward-kill-word'
bind '"\C-H": backward-kill-word'
bind '"^[^?": backward-kill-word'

bind '"\C-ge": edit-and-execute-command'

# move one dir up
bind '"\e[1;5H": "\C-u cd ..\n"'

# Bash 4.2+ (Readline 6.2+)
# the number of screen columns used to display possible matches when performing completion.
# ignored if it is less than 0 or greater than terminal screen width.
# 0 will cause matches to be displayed one per line.
# default -1.
bind 'set completion-display-width 0'

#bind fzf to crtl+f
bind -x '"\C-f": "fzf"'


#makes fzf search from home and ignore git
#export FZF_DEFAULT_COMMAND='find ~ -type f -not -path "*/\.git/*"'
#export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude .cache --exclude .local/share/Trash ~"
export FZF_DEFAULT_COMMAND="rg --files --hidden \
    -g '!Trash' \
    -g '!node_modules' \
    -g '!.git' \
    $HOME"



# ble.sh
[[ ! ${BLE_VERSION-} ]] || ble-attach

