#!/usr/bin/env bash

SCRIPT=`pwd`/$0
FILENAME=`basename $SCRIPT`
PATHNAME=`dirname $SCRIPT`
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=`pwd`
NVM_CHECK="$PATHNAME"/checkNvm.sh
EXTRAS=$ROOT/extras

function init_nginx()
{
    if [[ ! -f "/usr/sbin/nginx" ]]; then
        sudo yum install -y nginx
    fi
    sudo nginx -c $EXTRAS/basic_example/nginx.conf
}

init_nginx

cp $ROOT/nuve/nuveClient/dist/nuve.js $EXTRAS/basic_example/

. $NVM_CHECK

nvm use
cd $EXTRAS/basic_example
node basicServer.js &

echo 'try this demo by chrome: https://yourip'
echo 'make sure to enable "load unsafe script" at the end of address bar!'
