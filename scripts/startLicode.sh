#!/usr/bin/env bash

SCRIPT=$(pwd)/$0
FILENAME=$(basename $SCRIPT)
PATHNAME=$(dirname $SCRIPT)
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=$(pwd)
EXTRAS=$ROOT/extras
DB_DIR="$BUILD_DIR"/db
LOG_DIR=$ROOT/logs

export PATH=$PATH:/usr/local/sbin
mkdir -p $LOG_DIR

start_mongo() {

    if ! pgrep mongod; then
        echo [licode] Starting mongodb
        if [ ! -d "$DB_DIR" ]; then
            mkdir -p "$DB_DIR"/db
        fi
        mongod --repair --dbpath $DB_DIR
        # mongod --dbpath $DB_DIR --logpath $LOG_DIR/mongo.log --fork
        nohup mongod --dbpath $DB_DIR --logpath $LOG_DIR/mongod.log >$LOG_DIR/mongod_start.log 2>&1 &
        echo "$!" >"$LOG_DIR/mongod.pid"

        sleep 5
    else
        echo [licode] mongodb already running
    fi

    dbURL=$(grep "config.nuve.dataBaseURL" $PATHNAME/licode_default.js)

    dbURL=$(echo $dbURL | cut -d'"' -f 2)
    dbURL=$(echo $dbURL | cut -d'"' -f 1)

    echo [licode] Creating superservice in $dbURL
    mongo $dbURL --eval "db.services.insert({name: 'superService', key: '$RANDOM', rooms: []})" >$LOG_DIR/mongo.log 2>&1
    SERVID=$(mongo $dbURL --quiet --eval "db.services.findOne()._id")
    SERVKEY=$(mongo $dbURL --quiet --eval "db.services.findOne().key")

    SERVID=$(echo $SERVID | cut -d'"' -f 2)
    SERVID=$(echo $SERVID | cut -d'"' -f 1)

    if [ -f "$LOG_DIR/mongo.log" ]; then
        echo "Mongo Logs: $LOG_DIR/mongo.log"
        # cat $LOG_DIR/mongo.log
    fi

    echo [licode] SuperService ID $SERVID
    echo [licode] SuperService KEY $SERVKEY
    cd $BUILD_DIR
    replacement=s/_auto_generated_ID_/${SERVID}/
    sed $replacement $PATHNAME/licode_default.js >$BUILD_DIR/licode_1.js
    replacement=s/_auto_generated_KEY_/${SERVKEY}/
    sed $replacement $BUILD_DIR/licode_1.js >$ROOT/licode_config.js
    rm $BUILD_DIR/licode_1.js
}

function start_rabbitmq() {
    if ! pgrep -f rabbitmq; then
        # sudo echo
        sudo nohup rabbitmq-server >$LOG_DIR/rabbit.log 2>&1 &
        echo "$!" >"$LOG_DIR/rabbit.pid"
    fi
    sleep 5
}

function start_nuve() {
    cd $ROOT/nuve
    ./initNuve.sh
    sleep 5
}

function start_erizo_controller() {
    export ERIZO_HOME=$ROOT/erizo/
    cd $ROOT/erizo_controller
    ./initErizo_controller.sh
}

function start_erizo_agent() {
    export ERIZO_HOME=$ROOT/erizo/
    cd $ROOT/erizo_controller
    ./initErizo_agent.sh
    sleep 5
}

echo '--------start_mongo---------'
start_mongo

echo '--------start_rabbitmq---------'
start_rabbitmq

echo '------------start_nuve---------'
start_nuve

echo '------------start_erizo_agent----------'
start_erizo_agent

echo '------------start_erizo_controller----------'
start_erizo_controller

echo [licode] Done
