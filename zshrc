autoload -U colors && colors
export TERM=screen-256color
export GREP_OPTIONS='--color=auto'
export WORDCHARS='*?[]~&;!$%^<>'

# imports
. ~/.zsh/p.sh
. ~/.zsh/push.sh
. ~/.zsh/gifmess.sh
. ~/.zsh/prompts.sh
. ~/.zsh/z.sh

# ~/bin
if [[ -a ~/bin ]]; then
  PATH=$PATH:$HOME/bin
fi

if [[ -x "`whence -p selecta`" ]]; then
  . ~/.zsh/selecta.sh
fi

###### colorful ls #######
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls --color=auto'
fi

# completions
fpath=(~/.zsh/completions $fpath)
autoload -U ~/.zsh/completions/*(:t)
autoload -U compinit
compinit
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=2

###### aliases etc. #######
cdpath=( . ~ )

export EDITOR='subl --wait'

# shortcuts
alias e=subl
alias runashell="sudo pkill -KILL -u"
alias p2="python2"
alias p3="python3"

alias git="LANG=en_GB git"

alias boom="noglob boom"

# wrong keyboard layout
alias ап=fg
alias св=cd
alias ды=ls

###### history ######
HISTSIZE=10240 # кол-во команд, хранимых шеллом в текущей сессии
setopt COMPLETE_ALIASES
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

#if [ $(hostname | cut -c1-1) "!=" "h" ]; then
  HISTFILE=~/.history
  SAVEHIST=8192 # кол-во команд, которые будут сохранены в истории

  setopt SHARE_HISTORY
  setopt HIST_NO_STORE
#fi

###### vcs #######
# Allow for functions in the prompt.
setopt PROMPT_SUBST
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# Append vcs functions needed for prompt.
preexec_functions=($preexec_functions 'preexec_update_vcs_vars')
precmd_functions=($precmd_functions 'precmd_update_vcs_vars')
chpwd_functions=($chpwd_functions 'chpwd_update_vcs_vars')
# Enable auto-execution of functions.
$preexec_functions; $precmd_functions; $chpwd_functions

###### bindkeys ######
bindkey "\e[A" history-beginning-search-backward
bindkey "^[OA" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
bindkey "^[OB" history-beginning-search-forward
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# for guake
bindkey "\eOF" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "\e[3~" delete-char # Del

# alt-s => bitch,
alias bitch,=sudo
insert_sudo () { zle beginning-of-line; zle -U "bitch, " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo
