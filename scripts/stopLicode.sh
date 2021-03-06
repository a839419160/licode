#!/usr/bin/env bash

SCRIPT=`pwd`/$0
FILENAME=`basename $SCRIPT`
PATHNAME=`dirname $SCRIPT`
ROOT=$PATHNAME/..
LOG_DIR=$ROOT/logs


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
                if [ -n "$CPIDS" ]; then
                    CCPIDS=$(pgrep -P $CPIDS)
                fi
                if [ -n "$CCPIDS" ]; then
                    CCCPIDS=$(pgrep -P $CCPIDS)
                fi
 
                echo -e "`basename $path`\t\t\t\t kill -9 $PID $CPIDS $CCPIDS $CCCPIDS"
                sudo kill -9 $PID $CPIDS $CCPIDS $CCCPIDS > /dev/null 2>&1
                sudo rm $path
            fi
        fi
    done
}

function killbydir() {
    killbypid $LOG_DIR
}

echo '-------------------stop all licode services--------------------'
read -r -p "kill mongod rabbitmq erizoAgent erizoController, are you sure? [Y/n] " input

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
