autoload -U colors && colors
export TERM=xterm-256color

# Set the prompt.
# current directory
PROMPT='%{$bg[yellow]%}%{$fg_bold[white]%}%B%~%b%{$reset_color%}'
# git branch
PROMPT+='$(prompt_git_info)'
# background jobs
PROMPT+='%(1j. %{$bg[white]%}%{$fg[gray]%}%j%{$reset_color%}.) '

# differentiate hosts by color
RPROMPT="%{$bg[magenta]%}"
# (echo "ibase=16"; hostname | md5sum | cut -c1-2) | bc | awk '{printf "\x1b[48;5;%dm \x1b[38;5;13m &", $1}'
case $(hostname) in
    nearth)
        RPROMPT="%{$bg[green]%}";;
    terra)
        RPROMPT="%{$bg[yellow]%}";;
    hulk)
        RPROMPT="%{$bg[blue]%}";;
esac
# active username
RPROMPT+="%{$fg_bold[white]%}%n%{$reset_color%}"

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

export EDITOR=~/bin/sublime
export SUBLIME=~/bin/sublime
export BROWSER=/usr/bin/google-chrome

# shortcuts
alias e=$EDITOR
alias cr=$BROWSER
alias ci="$BROWSER --incognito"
alias runashell="sudo pkill -KILL -u"
alias runvnc="vncserver -depth 8 -geometry 1024x768 :5"
alias kilvnc="vncserver -kill :5"
alias p2="python2.7 -c"
alias p3="python3.3 -c"

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

###### git #######
# Allow for functions in the prompt.
setopt PROMPT_SUBST
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
