#!/usr/bin/env bash
SFILE=`pwd`/$0
SPATH=`dirname $SFILE`



function restart_all()
{
    cd $SPATH
    ./stopLicode.sh
    ./stopBasicExample.sh
    ./startLicode.sh
    ./startBasicExample.sh
    cd -
}

restart_all
