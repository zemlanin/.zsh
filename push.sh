# send message to your devices via pushover.net API
# add next two or three lines to .bashrc/.zshrc to use this script

# export PUSHOVER_APP="your pushover.net app token"
# export PUSHOVER_USER="your pushover.net user key"
# optional:
# export PUSHOVER_DEVICE="default device"

# USAGE: push <message> [-d=<device>]
# OPTIONS:
#    -d      Device name (send to $PUSHOVER_DEVICE if empty)

__pushover(){
  local device=""
  local message=$1
  shift 1

  while getopts ":d:" OPTION
  do
    case $OPTION in
      d)
        device=$OPTARG
        ;;
    esac
  done

  if [[ -z $device ]]
  then
    device=$PUSHOVER_DEVICE
  fi

  if [[ -z $message ]]
  then
    echo 'message required'
  else
    command curl -s -F "token=$PUSHOVER_APP" \
      -F "user=$PUSHOVER_USER" \
      -F "message=$message" \
      -F "device=$device" \
      https://api.pushover.net/1/messages.json
  fi
}

alias push=__pushover
