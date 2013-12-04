autoload -U colors && colors
export TERM=xterm-256color

# Set the prompt.
# current directory
# emoji in ubuntu: https://gist.github.com/zemlanin/5321821
PROMPT='%{$bg[yellow]%}%{$fg_bold[white]%}%B%~%b%{$reset_color%} 🍔 '
# git branch
PROMPT+='$(prompt_vcs_info)'
# background jobs
PROMPT+='%(1j. %{$bg[white]%}%{$fg[gray]%}%j%{$reset_color%}.) '

# differentiate hosts by color
__colorcode=$(
  (
    echo "ibase=16"; hostname | md5sum | cut -c1-2 | tr "[:lower:]" "[:upper:]"
  ) | bc | awk '{printf "[48;5;%dm", $1}' # background
)

__colorcode+=$(
  (
    echo "ibase=16"; hostname | md5sum | cut -c3-4 | tr "[:lower:]" "[:upper:]"
  ) | bc | awk '{printf "[38;5;%dm", $1}' # foreground
)

RPROMPT='%{$__colorcode%}%n%{$reset_color%}'

###### autocompletion ######
# github.com/zsh-users/zsh-completions
fpath=(~/.zsh/zsh-completions/src $fpath)
rm -f ~/.zcompdump; compinit

###### colorful ls #######
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls -F --color=auto'
else
  alias ls='ls -F'
fi

# a little dangerous staff
# TMUX
#if which tmux 2>&1 >/dev/null; then
    #if not inside a tmux session, and if no session is started, start a new session
#    test -z "$TMUX" && (tmux attach || tmux new-session)
#fi

###### aliases etc. #######
cdpath=( . ~ )
PATH=$PATH:~/bin
export PATH

export EDITOR='subl --wait'
export BROWSER=chromium-browser

# shortcuts
__p(){
  local args
  local i
  local index=0
  for i in "$@"; do
    args+="_$index=eval('$i'); print('\t_$index>', _$index);"
    let "index+=1"
  done
  command python3 -c "$args"
}
alias p="noglob __p"
  # p 2+4 4.0/3 _0+_1
  # output: 
  #   _0> 6
  #   _1> 1.3333333333333333
  #   _2> 7.333333333333333

__pushover(){

  DEVICE=""
  MESSAGE=""
  while getopts ":d:m:" OPTION
  do
    case $OPTION in
      d)
        DEVICE=$OPTARG
        ;;
      m)
        MESSAGE=$OPTARG
        ;;
    esac
  done

  if [[ -z $MESSAGE ]]
  then
    echo '-m option required'
  else
  command curl -s -F "token=$PUSHOVER_APP" \
    -F "user=$PUSHOVER_USER" \
    -F "message=$MESSAGE" \
    -F "device=$DEVICE" \
    https://api.pushover.net/1/messages.json
  fi
}

alias push=__pushover
  # send message to your devices via pushover.net API
  # add next two line to .bashrc/.zshrc to use this script

  # export PUSHOVER_APP="your pushover.net app token"
  # export PUSHOVER_USER="your pushover.net user key"

  # OPTIONS:
  #    -m      Message (required)
  #    -d      Device name (send to all devices if empty)

alias e=subl
alias k=tree
alias cr=$BROWSER
alias ci="$BROWSER --incognito"
alias runashell="sudo pkill -KILL -u"
alias runvnc="vncserver -depth 8 -geometry 1024x768 :5"
alias kilvnc="vncserver -kill :5"
alias p2="python2"
alias p3="python3"

# https://github.com/github/hub#rake-install-from-source
alias git="hub"

# wrong keyboard layout
alias ап=fg
alias св=cd
alias ды=ls

###### history ######
HISTSIZE=10240 # кол-во команд, хранимых шеллом в текущей сессии
setopt COMPLETE_ALIASES
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

if [ $(hostname | cut -c1-1) "!=" "h" ]; then
  HISTFILE=~/.history
  SAVEHIST=8192 # кол-во команд, которые будут сохранены в истории

  setopt SHARE_HISTORY
  setopt HIST_NO_STORE
fi

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

###### hub ######

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
