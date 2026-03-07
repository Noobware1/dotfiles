type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50
SAVEHIST=50

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/harsh/.zshrc'

autoload -Uz compinit
compinit

# alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

alias icat="kitten icat"
alias v="nvim"
alias py="source ~/dev/python/bin/activate"
alias pyq="deactivate"
alias wal="matugen -v image"
alias penpot="~/dev/dotfiles/penpot/penpot.sh"
alias svgtoqml="/lib/qt6/bin/svgtoqml"
alias py="python3"
alias cp="rsync -ah --progress"
alias sleep="systemctl suspend"

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

function ecp() {
	"$@" 2> >(tee /dev/stderr | wl-copy)
}

function csheet() {
	cat ~/cheatsheet.txt
}

function cool() {
	echo $1 | sudo tee /sys/devices/platform/msi-ec/cooler_boost
}

function shift-mode() {
	if [[ "$1" == "list" ]]; then
		cat /sys/devices/platform/msi-ec/available_shift_modes
	elif [[ "$1" == "" ]]; then
		cat /sys/devices/platform/msi-ec/shift_mode
	else
		echo $1 | sudo tee /sys/devices/platform/msi-ec/shift_mode
		echo ""
	fi
}

function ssh-start() {	
eval "$(ssh-agent -s)"
ssh-add ~/github
}



fpath=(~/.zsh/completions $fpath)

. $HOME/.cargo/env
