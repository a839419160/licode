#!/usr/bin/env bash
set -e

SCRIPT=`pwd`/$0
FILENAME=`basename $SCRIPT`
ROOT=`dirname $SCRIPT`
LICODE_ROOT="$ROOT"/..
CURRENT_DIR=`pwd`
NVM_CHECK="$LICODE_ROOT"/scripts/checkNvm.sh
LOG_DIR=$ROOT/../logs

. $NVM_CHECK

cd $ROOT/erizoAgent
nvm use
nohup node erizoAgent.js $* > $LOG_DIR/erizoAgent.log 2>&1 &
echo "$!" > $LOG_DIR/erizoAgent.pid

cd $CURRENT_DIR
