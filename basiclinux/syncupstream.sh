#!/bin/bash

# Syncing with upstream

git remote | grep upstream >> /dev/null 2>&1

if [ "$?" != "0" ]; then
        printf "Adding upstream git repo\n"
        #git remote add upstream git@github.com:tenzindorji/basic_linux.git
        git remote add upstream https://github.com/tenzindorji/basic_linux.git
else
        printf "\n"
fi

git pull && \
  git fetch upstream && \
  git merge upstream/master -m "Merge remote-tracking branch 'upstream/master'" && \
  git push

printf "\n"
