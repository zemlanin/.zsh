# Interface for gif archive

# USAGE: gifmess [url|open|cat] query

GIFMESS_PATH='/Dropbox/Public/gifmess/'

gifmess(){
    local cmd query
    local results=0

    if [ -z $1 ]; then
        echo "Usage: gifmess [url|open] query";
        return
    fi

    if [ -z $2 ]; then
        query=$1;
    else
        cmd=$1;
        query=$2;
    fi

    command ls -d ~/Dropbox/Public/gifmess/* | grep '\(jpe\?g\|gif\|png\)$' | grep $GIFMESS_PATH'.*'$query \
        | case $cmd in
            (url)
                if which dropbox >/dev/null; then
                    xargs -L1 dropbox puburl
                elif [ -n GIFMESS_BASE ]; then
                    xargs -L1 sed -e 's|.*'$GIFMESS_PATH'|'$GIFMESS_BASE'|g'
                else
                    echo "install dropbox-cli or set GIFMESS_BASE env variable in .zshrc"
                fi
                ;;
            (open)
                if which xdg-open >/dev/null; then
                    xargs -L1 -P2 xdg-open
                elif which qlmanage >/dev/null; then
                    xargs qlmanage -p >/dev/null
                else
                    cat
                fi
                ;;
            (cat)
                cat
                ;;
            *)
                while read -r line; do
                    if which dropbox >/dev/null; then
                        dropbox puburl $line | tee >(cat) | read -r last_url
                    elif [ -n GIFMESS_BASE ]; then
                        echo $line | sed -e 's|.*'$GIFMESS_PATH'|'$GIFMESS_BASE'|g' | tee >(cat) | read -r last_url
                    else
                        echo "install dropbox-cli or set GIFMESS_BASE env variable in .zshrc"
                    fi
                    ((results++))
                done
                if [ $results -eq 1 ]; then
                    if which xclip >/dev/null; then
                        echo $last_url | tr '\n' ' ' | xclip -sel clip;
                        echo copied
                    elif which pbcopy >/dev/null; then
                        echo $last_url | tr '\n' ' ' | pbcopy;
                        echo copied
                    else
                        echo "install xclip or pbcopy"
                    fi
                fi
                ;;
        esac
}
