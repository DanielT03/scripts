#!/usr/bin/env bash
SERVER=$1

RED='\e[31m'
GREEN='\e[32m'
NC='\e[0m'

if [ $# -lt 1 ]; then
  echo -e "Usage: $0 Servername"
  echo -e "$RED No Server defined!$NC"
  exit 1 
fi


BASHCONFIG=~/.bashrc

if [[ -f $BASHCONFIG ]]; then
  echo "Making backup of remote .bashrc ..."
  ssh -n $SERVER cp .bashrc .bashrc.$(date '+%Y%m%d')
  echo "Copying $BASHCONFIG to $SERVER using scp ..."
  scp $BASHCONFIG $SERVER:./
  echo -e "$GREEN Done!$NC\n"
else
  echo -e "$RED$(BASHCONFIG) not found!$NC\n"
fi
