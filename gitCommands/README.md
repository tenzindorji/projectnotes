## Git Commands

# Resolving git conflicts:
  - It occurs when two users make changes to same line of code.
  - After resolving code conflicts by deleting the conflicting code from git UI, need to merge the commits
  - and Merge the pull request to master

# Git cherry-pick
- when to use it?
  - `man git-cherry-pick`
  - used for hotfix and when there is multiple branch and team.
  - some time it will cause the merge conflict.
  - command:
  `git cherry-pick <sha1 git log>`

# checkout branch, fetch and pull
- `git checkout master` #swtich to master branch 
- `git checkout feature` #swtich to feature branch
- `git pull` #pull latest update
- `git checkout yourbranch` #switch to your branch created on Git UI.
- `git push origin yourbranch` #push the changes to your branch and then merge to master by creating pull request
- `git fetch `

## merge feature branch to master
`git checkout master`\
`git merge --squash feature`\
`git commit -m "feature and master merged"`

## fetch/pull
`git fetch master` # pulls the meta data but doesn't download actual contents. It is to check if there is any latest changes in master.\
`git pull orgin master` # pulls the latest content from the remote repo.

## checkout single file from remote
`git checkout origin/master -- filename or full_path`

## Create local and remote branch
```
git checkout master
git branch <branchname> #local
git checkout <branchname>
git push -u origin <branchname> #remote
```
## Delete remote and local branch
```
git branch -D <branchname>` # local\
git push origin --delete <branchname> #remote
```

## Rebase: How to remove multiple commits and combine to single commits
```
 git checkout master
 git pull
 git checkout yourbranch
 git rebase -i origin/master # On the last commit line and update pick to "s". DONOT delete any of the previous commit. Please as PICK. 
                             # this will combine all the commits to one single commit
                             # Also keep one commit message, remove rest of commit messages which are not required
git rebase origin/different_branch # rebase with different branch
git log # should see only one commit
git push --force
```
## Create branch from remove branch and push to remote repo
```
git checkout -b <new_branch> origin/<remote_branch>
git push -u origin HEAD
```
## Tagging 
`git tag` # list the tags\
`git tag -l "v1.8.5*"` # search tag\
`git tag -a v1.4 -m "my version 1.4"` #creating tagging and annotating 

## Branch owner:
`git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p)    %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authordate refs/remotes`


