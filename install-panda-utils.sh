#!/usr/bin/env bash

#Get rid of unused artifacts from previous installations
if [ "$1" == "purge" ]
then
	echo "Are you sure you want to purge /usr/local/automation ? (y/n)"
	read PURGE

	if [ $PURGE = 'y' ]
	then
		echo "purging..."
		rm -rf /usr/local/automation
	else
		echo "canceling purge..."
	fi
fi

# Make automation directory structure in usr/local
echo "creating /usr/local/automation directory structure..."
mkdir -p /usr/local/automation
mkdir -p /usr/local/automation/bin

# Add panda runner to /usr/local/bin
echo "adding panda runner to /usr/local/bin... "
ln -sf $PWD/Panda.sh /usr/local/bin/panda
ln -sf $PWD/.command-completion.sh /usr/local/automation/bin/.command-completion

cd inspection_diff_scope
# run diff scope installation
./install.sh

echo "done."
