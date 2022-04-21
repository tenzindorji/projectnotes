#! /bin/bash

set +ex
gitdir=/c/Users/P2980250/work


echo "rebasing git"
git -C ${gitdir}/control-repo checkout production && git -C ${gitdir}/control-repo pull && git -C ${gitdir}/control-repo fetch -p
git -C ${gitdir}/control-repo checkout new_puppet_master && git -C ${gitdir}/control-repo rebase origin/production && git -C ${gitdir}/control-repo push --force


git -C ${gitdir}/hieradata checkout master && git -C ${gitdir}/hieradata pull && git -C ${gitdir}/hieradata fetch -p
git -C ${gitdir}/hieradata checkout new_puppet_master && git -C ${gitdir}/hieradata rebase origin/master && git -C ${gitdir}/hieradata push --force
