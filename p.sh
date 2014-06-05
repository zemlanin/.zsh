# python quick calculation in zsh
# https://gist.github.com/zemlanin/5322437

# input:
#   p 2+4 4.0/3 _0+_1
#
# and get output like: 
#   _0> 6
#   _1> 1.3333333333333333
#   _2> 7.333333333333333

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
