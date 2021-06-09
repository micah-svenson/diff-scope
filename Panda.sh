#!/bin/bash

# Initialize path variables
#CONFIG_PATH=../automation/config
BIN_PATH=/usr/local/automation/bin
PATH="${PATH}:/usr/local/bin"

if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "Available Commands: "
	ls /usr/local/automation/bin
else
	if [ $# -gt 0 ]; then
	    if [ -x "$BIN_PATH/$1" ]; then
		$BIN_PATH/"$@"
	    else
		echo "command: $1 not recognized"
	    fi
	else
	    echo "no command entered"
	fi
fi

