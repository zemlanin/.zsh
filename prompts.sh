# emoji in ubuntu: https://gist.github.com/zemlanin/5321821
PROMPT='%{$bg[yellow]%}%{$fg_bold[white]%}%B%~%b%{$reset_color%} '
PROMPT+='$(prompt_vcs_info)'                                        # vcs info
PROMPT+='%(1j. %{$bg[white]%}%{$fg[gray]%}%j%{$reset_color%}.) '    # background jobs

# differentiate hostname by color
# https://gist.github.com/zemlanin/5325942
__colorcode=$(
  (
    echo "ibase=16"; hostname -s | md5sum | cut -c1-2 | tr "[:lower:]" "[:upper:]"
  ) | bc | awk '{printf "[48;5;%dm", $1}' # background
)

__colorcode+=$(
  (
    echo "ibase=16"; hostname -s | md5sum | cut -c3-4 | tr "[:lower:]" "[:upper:]"
  ) | bc | awk '{printf "[38;5;%dm", $1}' # foreground
)

RPROMPT='%{$__colorcode%}%n%{$reset_color%}'


# http://stackoverflow.com/a/26585789
strlen () {
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
}

# show right prompt with date ONLY when command is executed
preexec () {
    DATE=$(date +'%H:%M:%S %d.%m.%Y')
    local right_start=$(($COLUMNS - 20)) #  $( strlen "$DATE" ) + 1

    local len_cmd=$( strlen "$@" )
    local len_prompt=$(strlen "$PROMPT" )
    local len_left=$(($len_cmd+$len_prompt))

    RDATE="\033[${right_start}C${DATE}"

    if [ $len_left -lt $right_start ]; then
        # command does not overwrite right prompt
        # ok to move up one line
        echo -e "\033[1A${__colorcode}${RDATE}${reset_color}"
    else
        echo -e "${__colorcode}${RDATE}${reset_color}"
    fi
}
