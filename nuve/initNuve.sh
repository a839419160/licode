#!/usr/bin/env bash

set -e

SCRIPT=`pwd`/$0
FILENAME=`basename $SCRIPT`
PATHNAME=`dirname $SCRIPT`
ROOT=$PATHNAME/..
NVM_CHECK="$ROOT"/scripts/checkNvm.sh
CURRENT_DIR=`pwd`
LOG_DIR=$ROOT/logs

. $NVM_CHECK

cd $PATHNAME/nuveAPI

nohup node nuve.js > $LOG_DIR/nuve.log 2>&1 &
echo "$!" > $LOG_DIR/nuve.pid

cd $CURRENT_DIR
