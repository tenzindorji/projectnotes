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
- `git checkout master` # swtich to master branch and get the latest update by using pull
- `git pull` # pull latest update
- `git checkout yourbranch` # switch to your branch created on Git UI.
- `git push origin yourbranch` # push the changes to your branch and then merge to master by creating pull request

- `git fetch `

## merge feature branch to master
`git checkout master`
`git merge --squash feature`\
`git commit -m "feature and master merged"`

## rebase command - merge feature branch to master and put feature commits as a latest commits.
`git checkout master`
`git rebase feature`\
`git log`

## fetch/pull
`git fetch master` # pulls the meta data but doesn't download actual contents. It is to check if there is any latest changes in master.\
`git pull orgin master` # pulls the latest content from the remote repo.

## Delete remote and local branch
```
git branch -D <branchname>`
git push origin --delete <branchname>
```

## Rebase: How to remove multiple commits and combine to single commits
```
 git checkout master
 git pull
 git checkout yourbranch
 git rebase -i origin/master # On the last commit line and update pick to "s". DONOT delete any of the previous commit. Please as PICK. 
                             # this will combine all the commits to one single commit
                             # Also keep one commit message, remove rest of commit messages which are not required
git log # should see only one commit
git push origin yourbranch --force
```
## Create branch from remove branch and push to remote repo
```
git checkout -b <new_branch> origin/<remote_branch>
git push -u origin HEAD
```
