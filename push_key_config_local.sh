#!/usr/bin/env bash
SERVER=$1
USER=$(whoami)

BASHCONFIG=/home/$USER/.bashrc
SSHPUBKEY=/home/$USER/.ssh/id_rsa.pub
TMUXCONFIG=/home/$USER/.tmux.conf

RED='\e[31m'
GREEN='\e[32m'
NC='\e[0m'

if [[ -f $SSHPUBKEY ]]; then
  echo "Copying $(SSHPUBKEY) to $SERVER using ssh-copy-id ..."
  ssh-copy-id -i $SSHPUBKEY $1
  if [[ $? -eq 0 ]]; then
    echo -e "$GREEN Done!$NC\n"
  else
    echo -e "$RED ssh-copy-id failed with status code $?. Aborting further process!$NC"
    exit $?
  fi
else
  echo -e "$RED$SSHPUBKEY does not exist!$NC No SSH-Key was transfered to the server."
  echo -e "Try to copy .bashrc and .tmux.conf anyway? (1 or 2)"
  select yn in "Yes" "No"; do 
   case $yn in 
     Yes ) break;;
     No ) exit 1;;
   esac
  done
fi

if [[ -f $BASHCONFIG ]]; then
  echo "Making backup of remote .bashrc ..."
  ssh -n $SERVER cp .bashrc .bashrc.$(date '+%Y%m%d')
  echo "Copying $BASHCONFIG to $SERVER using scp ..."
  scp $BASHCONFIG $SERVER:./
  echo -e "$GREEN Done!$NC\n"
else
  echo -e "$RED$(BASHCONFIG) not found!$NC\n"
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

