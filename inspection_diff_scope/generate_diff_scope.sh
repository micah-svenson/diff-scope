#/usr/bin/env bash

# This script uses git diff to generate a custom webstorm scope, which 
# allows the user to run a code inspection on changes between the feature branch and develop branch

CURRENTBRANCH=$(git rev-parse --abbrev-ref HEAD) ||
		(tput setaf 1; echo "git error: checkout output above"; exit 1;)
# The path of the webstorm project root
PROJECTPATH=$(pwd)
# The path of the repository being inspected
REPOPATH=$(pwd)
#find the root of the webstorm project to access the workspace.xml file
for i in {0,3}
do
	# if file exists
	if [ -f "$PROJECTPATH/.idea/workspace.xml" ]
	then
		break;
	else
	#get path of parent and try again
	PROJECTPATH=$(dirname "$PROJECTPATH")
fi
done
WEBSTORMWORKSPACE="$PROJECTPATH/.idea/workspace.xml"

# display help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]
then
	echo "Create a custom Webstorm scope called inspection-diff"
	echo "The generated scope is accessible within Webstorm."
else

	echo -n "Is $(pwd) the desired repository path (y/n)? "
	read CORRECTPATH
	if [ "$CORRECTPATH" != 'y' ]
	then
		tput setaf 1; echo 'Navigate to desired repository and try again.'
		exit 1
	fi


	if [ "$CURRENTBRANCH" == '' ]
	then 
		tput setaf 1; echo 'Current directory is not a respository'
		exit 1
	fi

	echo "Your current branch is: $(tput setaf 2)$CURRENTBRANCH$(tput sgr0)"
	echo -n "Enter name of comparison branch: "
	read COMPARISONBRANCH

	echo "Creating Scope for file changes between $(tput setaf 2) $COMPARISONBRANCH $(tput sgr0) and $(tput setaf 2) $CURRENTBRANCH$(tput sgr0)..." 

	#Get the file changes
	git diff $CURRENTBRANCH $COMPARISONBRANCH --name-only --relative > .tmp.txt ||
		(tput setaf 1; echo "git error: checkout output above"; exit 1;)
	# Find relative path between test repo and root
	RELATIVEPATH="$(echo $REPOPATH/  | sed "s#$PROJECTPATH/##g")"
	# If there is a relative path append to file names
	if [ RELATIVEPATH != '' ]
	then
		sed -i "s#^#$RELATIVEPATH#" .tmp.txt
	fi	
	#Holds the files to inspect using the pattern syntax for Scopes 
	PATTERN=$(awk '{printf "file:%s||",$1;next}END{printf "file:%s", $1}' .tmp.txt)
	rm .tmp.txt
	#The xml synax for storing a scope
	SCOPE="\    <scope name=\"inspection-diff\" pattern=\"$PATTERN\" />"
	#Becuase MacOS doesnt have gnu spec sed
	if [ "$OSTYPE" == 'linux-gnu' ] 
	then #linux
		#Delete the previous inspection-diff scope
		sed -i "/<scope name=\"inspection-diff\"/d" $WEBSTORMWORKSPACE
		#Add the new scope
		sed -i "/<component name=\"NamedScopeManager\">/a $SCOPE" $WEBSTORMWORKSPACE
	else #MAC
		#Delete the previous inspection-diff scope
		sed -i .txt "/<scope name=\"inspection-diff\"/d" $WEBSTORMWORKSPACE
		sed -i .txt "/<component name=\"NamedScopeManager\">/a\ 
			$SCOPE
		" $WEBSTORMWORKSPACE
	fi

	SCOPEADDED=$(cat $WEBSTORMWORKSPACE | grep inspection-diff)

	if [ "$SCOPEADDED" == '' ]
	then
		tput setaf 1; echo -e "\nFailed to add scope, Scope Manager doesnt exist."
		exit 1
	else
		tput setaf 2; echo -e "\nNew scope $(tput bold)inspection-diff$(tput sgr0; tput setaf 2) has been created"
	fi

fi	
