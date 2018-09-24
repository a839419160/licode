#!/usr/bin/env bash
# warning: this will kill all node mongod rabbitmq

function kill_all()
{
    sudo pkill -9 node
    sudo pkill -9 mongod
    # sudo pkill -9 rabbitmq
    sudo pkill -9 beam.smp
    sudo pkill -9 epmd
}

read -r -p "this will kill all node mongod rabbitmq, Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
        kill_all
		;;

    [nN][oO]|[nN])
       		;;

    *)
	echo "Invalid input..."
	exit 1
	;;
esac


