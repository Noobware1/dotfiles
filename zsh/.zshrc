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
# End of lines added by compinstall

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

alias icat="kitten icat"
alias v="nvim"
. $HOME/.cargo/env
alias py="source ~/dev/python/bin/activate"
alias pyq="deactivate"
alias wal="matugen -v image"
alias penpot="~/dev/dotfiles/penpot/penpot.sh"
alias svgtoqml="/lib/qt6/bin/svgtoqml"
alias py="python3"

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

function ecp() {
	"$@" 2> >(tee /dev/stderr | wl-copy)
}

fpath=(~/.zsh/completions $fpath)
