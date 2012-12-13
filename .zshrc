autoload -U colors && colors

# Set the prompt.
PROMPT='%{$bg[yellow]%}%{$fg[black]%}%B%~%b%{$reset_color%}'
PROMPT+='$(prompt_git_info)'
PROMPT+='%(1j. %{$bg[white]%}%{$fg[gray]%}%j%{$reset_color%}.) '

RPROMPT="%{$bg[magenta]%}"
case $(hostname) in
    nearth)
        RPROMPT="%{$bg[green]%}";;
    hulk)
        RPROMPT="%{$bg[blue]%}";;
esac
RPROMPT+="%{$fg_bold[white]%}%n%{$reset_color%}"

###### colorful ls #######
if [[ -x "`whence -p dircolors`" ]]; then
  eval `dircolors`
  alias ls='ls -F --color=auto'
else
  alias ls='ls -F'
fi

# TMUX
#if which tmux 2>&1 >/dev/null; then
    #if not inside a tmux session, and if no session is started, start a new session
#    test -z "$TMUX" && (tmux attach || tmux new-session)
#fi

###### aliases etc. #######
cdpath=( . ~ ~/Dropbox /media/Mess )

export EDITOR=vim
export SUBLIME=~/.sublime/sublime_text
export BROWSER=/usr/bin/firefox

# Set up auto extension stuff
alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s ru=$BROWSER
alias -s ua=$BROWSER
alias -s txt=$EDITOR
alias -s java=$EDITOR
alias -s py=$EDITOR
alias -s asm=$EDITOR
alias -s avi=mplayer
alias -s mp3=mplayer
alias -s mp4=mplayer

# shortcuts
alias sb=$SUBLIME
alias cr=$BROWSER
alias ci="$BROWSER --incognito"
alias sa="sudo apt-get"
alias mpsh="mplayer -shuffle /media/Mess/Music/*/*/*"
alias mfnd="find -path /media/Mess -exec mplayer {} \; -name"
alias trare="transmission-remote"
alias runashell="sudo pkill -KILL -u"
alias runvnc="vncserver -depth 8 -geometry 1024x768 :5"
alias kilvnc="vncserver -kill :5"

# wrong keyboard layout
alias ап=fg
alias св=cd
alias лы=ls

###### history ######
HISTFILE=~/.history
HISTSIZE=10240 # кол-во команд, хранимых шеллом в текущей сессии
SAVEHIST=8192 # кол-во команд, которые будут сохранены в истории

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt COMPLETE_ALIASES

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
