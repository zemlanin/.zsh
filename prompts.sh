# emoji in ubuntu: https://gist.github.com/zemlanin/5321821
PROMPT='%{$bg[yellow]%}%{$fg_bold[white]%}%B%~%b%{$reset_color%} 🍔 '
PROMPT+='$(prompt_vcs_info)'                                        # vcs info
PROMPT+='%(1j. %{$bg[white]%}%{$fg[gray]%}%j%{$reset_color%}.) '    # background jobs

# differentiate hostname by color
# https://gist.github.com/zemlanin/5325942
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
