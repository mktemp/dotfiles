#!/bin/bash

# Used in fcrontab for mantaining the packages list

cd ~/r/dotfiles/
yaourt -Qeq > packages 
if ( git log -1 | tail -n 1 | grep "Update the packages list$" ); then
    git commit packages --amend --no-edit --reset-author  # --reset-author updates the ts
else
    git commit packages -m "Update the packages list"
fi 
