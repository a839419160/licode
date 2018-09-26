#!/usr/bin/env bash

SCRIPT=$(pwd)/$0
FILENAME=$(basename $SCRIPT)
PATHNAME=$(dirname $SCRIPT)
ROOT=$PATHNAME/..
DEMO_LOG_DIR=$ROOT/demo_logs

#kill process by pid file in dir
function killbypid() {
    for element in $(ls $1); do
        path=$1"/"$element
        if [ -d $path ]; then
            killbypid $path
        else
            if [[ $path =~ ".pid" ]]; then
                PID=$(cat $path)
                if [ ! -n "$PID" ]; then
                    echo "pid not exist"
                fi
                CPIDS=$(pgrep -P $PID)
 
                echo -e "`basename $path`\t\t\t\t kill -9 $PID $CPIDS "
                sudo kill -9 $PID $CPIDS > /dev/null 2>&1
                sudo rm $path
            fi
        fi
    done
}

function killbydir() {
    killbypid $DEMO_LOG_DIR
}

echo '---------------------stop example services-----------------'
read -r -p "kill nginx basicServer, are you sure? [Y/n] " input

case $input in
[yY][eE][sS] | [yY])
    killbydir
    ;;

[nN][oO] | [nN]) ;;

\
    *)
    echo "Invalid input..."
    exit 1
    ;;
esac
