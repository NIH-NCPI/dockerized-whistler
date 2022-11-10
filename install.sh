#!/bin/bash

set -e

# This script simply builds the docker image and copies the script
# over to $HOME/bin. 

# This must be run in the root directory of the dockerized-whistler
# repository, since that is where the Dockerfile is kept.

docker build -t torstees/whistler .
echo "-----------------------------------------------------------------------"
echo "A docker image, ncpi/whistler, has been created. "
echo "-----------------------------------------------------------------------"

EXECDIR=$HOME/bin
mkdir -p $EXECDIR
cp scripts/* $EXECDIR

echo "-----------------------------------------------------------------------"
echo "A script has been created at: $EXECDIR/whistler"
echo "This script will handle the docker related arguments allowing you run "
echo "whistle as if it were a native application" 
echo "-----------------------------------------------------------------------"

echo ""

echo "Add the following line to the file, .bash_profile, in your home"
echo "directory to ensure that the script is in your PATH:"
echo 
echo "export PATH=$PATH:$EXECDIR"
echo
echo "Then source the .bash_profile or log in again for the new PATH to take"
echo "effect. "
echo
echo "source $HOME/.bash_profile"

echo
echo "Once the script is in your PATH, you can run whistle like any other"
echo "command line tool:"
echo "whistle --help"
