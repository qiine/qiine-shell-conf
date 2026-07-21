#
# Aliases


## [Hardware]
#----------------------------------------------------------------------
alias lsblka='lsblk -o NAME,FSTYPE,SIZE,FSAVAIL,FSUSE%,LABEL,UUID,TYPE,MOUNTPOINTS'

alias off='systemctl poweroff' # cleaner than just `poweroff`
alias reboot='sudo reboot'
alias reboottobios='sudo systemctl reboot --firmware-setup'

alias swapflush='sudo swapoff -a && sudo swapon -a; free -h'


# Screens
alias kvirtmon='krfb-virtualmonitor'
alias kvirtmonnew='krfb-virtualmonitor --resolution 2480x1860 --name virtmon --password "" --port 5900'


### GPU
alias gpu='watch -n 0.5 nvidia-smi'



## [sys]
#----------------------------------------------------------------------
alias mnt='sudo mount'
alias umnt='sudo umount'
alias unmount='umount'

alias udsk='udisksctl'
alias udiskmnt='udisksctl mount --block-device'
alias udiskumnt='udisksctl unmount --block-device'


### pkgs
alias sysupdate='nixupdate && flatpak update -y'

# alias reinstall='sudo apt-get reinstall'
# alias uninstall='sudo apt remove'
# alias install='sudo apt install'

### ps
alias psv='ps -eo pid,user,pmem,pcpu,comm --sort=-pmem'
alias psvusrapp='ps -eo pid,user,tty,pmem,pcpu,comm --sort=-pcpu | grep -v "?"'

alias htopusr='htop -u qm'

### systemd
alias sctl='systemctl'


## Fonts
alias fontreload="sudo fc-cache -fv"
alias fontls="fc-list : family | sort -u"


#----------------------------------------------------------------------
## [NixOS]
#----------------------------------------------------------------------
alias nixbuild='sudo nixos-rebuild switch --flake /etc/nixos/' # rebuild flakes based conf
alias nixupdate='sudo nix flake update --flake /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos'
alias nixclean='sudo nix-collect-garbage --delete-older-than 5d && nix-store --optimise'
# alias nixopt='nixos-option'



#----------------------------------------------------------------------
## [fs]
#----------------------------------------------------------------------
alias mkfile='install -v -D /dev/null'

alias cp='cp -ipdv'
alias mv='mv -v'
alias rm='rm -v'
alias trash="trash-put"

alias permi='stat -c "%A %a"'

alias ls='ls --hyperlink=auto --color=auto'
alias ll='ls -goAFGh --group-directories-first --hyperlink=auto --color=auto'
alias l='ls -goAFGh --group-directories-first --hyperlink=auto --color=auto'


### dir
alias ..='cd ..'
alias c='cd'
alias rmemptydir='find . -mindepth 1 -type d -empty -print -delete'


### Symlink
alias link='ln -sfnv'
alias relink='ln -sfnv'


alias xdg-open='open'



#----------------------------------------------------------------------
## [Tools]
#----------------------------------------------------------------------
### git
alias giti='git init && git commit --allow-empty --allow-empty-message -m "In the beginning there was an idea"'
alias gitcl='git clone --recurse-submodules'

alias gittrack='git add --intent-to-add -v'
alias gittrackA='git add --intent-to-add -A -v'
alias gituntrack='git rm --cached -v'

alias gita='git add -v'
alias gits='git add -v'
alias gitacwd='git add . -v'  # add in cwd, recursively
alias gitA='git add -A -v' # add whole repo
alias gitaa='git add -A -v' # add whole repo
alias gitunstage='git reset HEAD' # or unadd
alias gitunadd='git reset HEAD'

alias gitc='git commit'
alias gitcm='git commit -m'
alias gituncommit='git reset --soft HEAD~1' # keep staged files, only for unpushed!

#### Branches
alias gitbranch='git branch'
alias gitbranchadd='git branch'
alias gitbranchrm='git branch -d'
alias gitbranchls='git branch'
alias gitbranchswitch='git switch'
alias gitbranchaddswitch='git switch -c'

#### Worktree
alias gitworkt='git worktree'
alias gitworkta='git worktree add'
alias gitworktrm='git worktree remove'
alias gitworktls='git worktree list'

alias gitP='git push'
alias gitp='git pull'
alias gitlsremote='git ls-remote'

alias gitst='git status'
alias gith='git log --since="Jan 1" --pretty=format:"[%ad] %s (%an)" --date=short'


alias cdg='cd "$(git rev-parse --show-toplevel)"' # cd git root


### Clipboard
clipb() {
    wl-copy -t text/uri-list file://"${1}"
}
alias clipbpaste='wl-paste'
alias clipbshow='wl-paste'


### vim
alias v='nvim'
alias neovim='nvim'
alias nvim!='nvim --clean'

alias scim='sc-im'


### Dev
alias mk='make -C "$(git rev-parse --show-toplevel)"'
alias maker='make -C "$(git rev-parse --show-toplevel)"'

alias denv='drienv'
alias denva='direnv allow'

## Luarocks
alias luarockinstproj='luarocks install --tree lua_modules'
alias luarockrm='luarocks remove'
alias luarockls='luarocks list'
alias luarocklocls='luarocks list --local'

#### python
alias uvpip='uv pip'
alias venvactivate='source .venv/bin/activate'


## Media
### PDF


### ffmpeg
alias fmpg='ffmpeg'

alias exif='exiftool'
alias exifclear='exiftool -all= -overwrite_original'


### org
## dstask
alias task='dstask'
alias taska='dstask add'
alias taskrm='dstask remove'
alias taskn='dstask note'
alias tasked='dstask edit'
alias taskls='dstask next'


### ytd
alias ytd='yt-dlp'
alias ytdslow='yt-dlp --concurrent-fragments 1 --limit-rate 150K --sleep-requests 4 --sleep-interval 5 --max-sleep-interval 7'


## Virtual
alias pod='podman'

alias dibox='distrobox'



## [Android]
#----------------------------------------------------------------------
### ADB
alias adbs='adb shell'

alias adbreboot='adb shell reboot'
alias adboff='adb shell reboot -p'

alias adbp='adb shell pm'
alias adbpkgls='adb shell pm list packages -a'
alias adbpkglssys='adb shell pm list packages -s'
alias adbpkglsusr='adb shell pm list packages -3'
alias adbpkghide='adb shell pm hide'
alias adbpkgdis='adb shell pm disable-user --user 0'
alias adbpkgu='adb shell pm uninstall -k --user 0'

### scrcpy
# alias scpy='scrcpy -w --render-driver=opengl --stay-awake'


## AI
alias lama='llama-cli'
alias lamas='llama-server'
alias lamaroute='llama-server --models-preset $HOME/Personal/dotfiles/User/AI/llamacpp_presets.ini --models-max 1 --presence_penalty 0.0 --repeat_penalty 1.0'
alias lamals='curl -s http://localhost:8080/models | jq'







