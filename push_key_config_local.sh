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

SSHPUBKEY=~/.ssh/id_rsa.pub
TMUXCONFIG=~/.tmux.conf
VIMCONFIG=~/.vimrc

if [[ -f $SSHPUBKEY ]]; then
  echo "Copying $(SSHPUBKEY) to $SERVER using ssh-copy-id ..."
  ssh-copy-id -i $SSHPUBKEY $SERVER
  RET=$?
  if [[ $RET -eq 0 ]]; then
    echo -e "$GREEN Done!$NC\n"
  else
    echo -e "$RED ssh-copy-id failed with status code $RET. Aborting further process!$NC"
    exit $RET
  fi
else
  echo -e "$RED$SSHPUBKEY does not exist!$NC No SSH-Key was transfered to the server."
  echo -e "Try to copy .tmux.conf anyway? (1 or 2)"
  select yn in "Yes" "No"; do 
   case $yn in 
     Yes ) break;;
     No ) exit 1;;
   esac
  done
fi

if [[ -f $TMUXCONFIG ]]; then
  echo "Making backup of remote .tmux.conf ..."
  ssh -n $SERVER cp .tmux.conf .tmux.conf.$(date '+%Y%m%d')
  echo -e "Copying $TMUXCONFIG to $SERVER using scp ..."
  scp $TMUXCONFIG $SERVER:./
  echo -e "$GREEN Done!$NC\n"
else
  echo -e "$RED $(TMUXCONFIG) not found!$NC"
fi

if [[ -f $VIMCONFIG ]]; then
  echo "Making backup of remote .vimrc ..."
  ssh -n $SERVER cp .vimrc .vimrc.$(date '+%Y%m%d')
  echo -e "Copying $VIMCONFIG to $SERVER using scp ..."
  scp $VIMCONFIG $SERVER:./
  echo -e "$GREEN Done!$NC\n"
else
  echo -e "$RED $(VIMCONFIG) not found!$NC"
fi

