# Interface for gif archive

# USAGE: gifmess [url|open|cat] query

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

    command ls -d ~/Dropbox/Public/gifmess/* | grep '\(jpe\?g\|gif\|png\)$' | grep $query \
        | case $cmd in
            (url)
                xargs -L1 dropbox puburl
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
                    dropbox puburl $line | tee >(cat) | read -r last_url
                    ((results++))
                done
                if [ $results -eq 1 ]; then
                    echo $last_url | tr '\n' ' ' | xclip -sel clip;
                    echo copied
                fi
                ;;
        esac
}
