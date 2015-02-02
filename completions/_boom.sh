#compdef boom

local state line cmds ret=1

_arguments -C '1: :->cmds' '*: :->args'

case $state in
  cmds)
    local -a cmds
    cmds=(
      'all:show all items in all lists'
      'edit:edit the boom JSON file in $EDITOR'
      'help:help text'
      'delete:deletes text'
      'copy:copies text without output'
      'echo:displays text without additional output'
    )
    _describe -t commands 'boom command' cmds && ret=0
    _values 'lists' $(boom | awk '{print $1}')
    ;;
  args)
    case $line[1] in
      (boom|all|edit|help)
        ;;
      (delete|copy|echo|open|random)
          if [[ "${#line[@]}" == "2" ]]; then
            _values 'lists' $(boom | awk '{print $1}')
          elif [[ "${#line[@]}" == "3" ]]; then
            _values 'items' `boom $line[2] | awk '{print $1}' | sed -e 's/://'` 2>/dev/null && ret=0
          fi
          ;;
      *)
        _values 'items' `boom $line[1] | awk '{print $1}' | sed -e 's/://'` 2>/dev/null && ret=0
        ;;
    esac
    ;;
esac

return ret
