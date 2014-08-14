# send yo to your devices via Yo API
# add next two line to .bashrc/.zshrc to use this script

# export YO_APP="your justyo.co app token"

# USAGE: yop [link]

__yop(){
  local link=$1
  local api_url="http://api.justyo.co/yoall/"

  command curl -s -F "api_token=$YO_APP" -F "link=$link" $api_url
}

alias yop=__yop
