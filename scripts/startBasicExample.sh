#!/usr/bin/env bash

SCRIPT=$(pwd)/$0
FILENAME=$(basename $SCRIPT)
PATHNAME=$(dirname $SCRIPT)
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=$(pwd)
NVM_CHECK="$PATHNAME"/checkNvm.sh
EXTRAS=$ROOT/extras
DEMO_LOG_DIR=$ROOT/demo_logs

mkdir -p $DEMO_LOG_DIR

function start_nginx() {
    if [[ ! -f "/usr/sbin/nginx" ]]; then
        sudo yum install -y nginx
    fi
    mkdir -p $DEMO_LOG_DIR
    sudo nginx -c $EXTRAS/basic_example/nginx.conf > $DEMO_LOG_DIR/nginx_start.log 2>&1
    cp /tmp/nginx.pid $DEMO_LOG_DIR/
}


function start_basic_example() {
    cp $ROOT/nuve/nuveClient/dist/nuve.js $EXTRAS/basic_example/
    . $NVM_CHECK
    nvm use
    cd $EXTRAS/basic_example
    nohup node basicServer.js > $DEMO_LOG_DIR/basicServer.log 2>&1 &
    echo "$!" > $DEMO_LOG_DIR/basicServer.pid
}

echo '--------------start nginx----------------'
start_nginx
echo '--------------start basicServer----------------'
start_basic_example
echo '----------------------------------------------------------------------------------------'
echo 'open in chrome: https://yourip , enable "load unsafe script" at the end of address bar!'
echo ''
echo '在chrome打开：https://yourip ，在地址拦后端打开“加载不安全脚本”即可'
