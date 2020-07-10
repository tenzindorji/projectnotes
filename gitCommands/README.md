## Git Commands

# Resolving git conflicts:
  - It occurs when two users make changes to same line of code.
  - After resolving code conflicts by deleting the conflicting code from git UI, need to merge the commits
  - and Merge the pull request to master

#Git cherry-pick
## when do use it?
  - `man git-cherry-pick` \n
  - used for hotfix and when there is multiple branch and team. \n
  - some time it will cause the merge conflict. \n
  - command \n
  `git cherry-pick <sha1 git log>`

# fetch/pull/checkout/merge/rebase
- `git checkout master` # change to master branch `git checkout feature` #change to feature branch
- `git fetch `

#merge feature branch to master
`git checkout master`
`git merge --squash feature`
`git commit -m "feature and master merged"`

#rebase command - merge feature branch to master and put feature commits as a latest commits.
`git checkout master`
`git rebase feature`
`git log`

#fetch/pull
`git fetch master` # pulls the meta data but doesn't download actual contents. It is to check if there is any latest changes in master.
`git pull orgin master` # pulls the latest content from the remote repo.
