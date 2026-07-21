
# zsh config


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/pnpm/bin:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR=nvim
export MANPAGER="nvim +Man!"


## [History]
HISTFILE="$HOME/Personal/dotfiles/User/Shell/zsh/history"

HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY


## [Completion]
setopt GLOB_COMPLETE  # hit the tab key will list possible completions, but not substitute them in the cmd prompt
setopt LIST_ROWS_FIRST
setopt LIST_PACKED

[[ -d "$HOME/.cache/zsh" ]] || mkdir -p "$HOME/.cache/zsh"

autoload -Uz compinit
compinit -C -d "$HOME/.cache/zsh/zcompdump"

# source <(carapace _carapace zsh)

# UI behavior
zstyle ':completion:*' menu select=7
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


# alias
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# bash func
[[ -r "$HOME/Personal/dotfiles/User/Shell/Bash/functions.sh" ]] &&
    . "$HOME/Personal/dotfiles/User/Shell/Bash/functions.sh"


## Prompt
eval "$(starship init zsh)"



## [Keybinds]
# to see what key terminal send: showkey -a

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey '?' backward-delete-char
bindkey '^[[3~' delete-char

bindkey '^[^?' backward-kill-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

bindkey '^[[3;3~' kill-line

# show comp menu
bindkey '^ ' menu-complete

