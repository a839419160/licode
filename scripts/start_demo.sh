#!/usr/bin/env bash

sudo pkill -9 node
nohup ./scripts/initLicode.sh > licode.log 2>&1 &
nohup ./scripts/initBasicExample.sh > example.log 2>&1 &
