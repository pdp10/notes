# Git


### Git diff / difftool
Instead of using git diff, use git difftool --tool=vimdiff.
The following code sets `vimdiff` as default tool:
```
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
# switch off the prompt at start
git config --global --add difftool.prompt false

git difftool <DEV_BRANCH> -- <FILE>
```

### Connecting to GitHub with ssh
Guide: https://help.github.com/articles/connecting-to-github-with-ssh/
If you already have your SSH keys set up and are still getting the password 
prompt, make sure your repo URL is in the form
```
git+ssh://git@github.com/username/reponame.git
```
as opposed to
```
https://github.com/username/reponame.git
```
To see your repo URL, run:

```
git remote show origin
```
You can change the URL with git remote set-url like so:
```
git remote set-url origin git+ssh://git@github.com/username/reponame.git
```

### git cherry-pick
To choose git commits manually
```
git checkout branch_name
git cherry-pick <COMMIT>
```


### Update the local list of remote branches: 
```
git remote update origin --prune
```


### Search for commits including a certain keyword in the log and checkout the commit
```
# find a modification in git history
git log --pickaxe-regex -p --color-words -S "text to search"
# check out a particular commit.
git checkout <COMMIT-SHA1>
```


### Git rebase
```
git checkout dev 
git pull origin dev
git checkout -b branch_name

git add .. 
git commit .. 
git checkout dev 
git checkout -
git rebase -i dev
```

## Git submodule
```bash
git submodule init
git submodule update
```

### Startup
```
# clone master
git clone https://github.com/pdp10/sbpipe.git
# get develop branch
git checkout -b develop origin/develop
# to update all the branches with remote
git fetch --all
```

### Update
```
git fetch && git merge --no-ff
git pull [--rebase] origin BRANCH
```

### Managing tags
```
# Update an existing tag to include the last commits
# Assuming that you are in the branch associated to the tag to update:
git tag -f -a tagName
# push your new commit:
git push
# force push your moved tag:
git push -f --tags origin tagName
    
# rename a tag
git tag new old
git tag -d old
git push origin :refs/tags/old
git push --tags
# make sure that the other users remove the deleted tag. Tell them(co-workers) to run the following command:
git pull --prune --tags
        
# removing a tag remotely and locally
git push --delete origin tagName
git tag -d tagName
```

### File system
```
git rm [--cache] filename
git add filename
```

### Information
```
git status
git log [--stat]
git branch       # list the branches
```

### Maintenance
```
git fsck      # check errors
git gc        # clean up
```

### Rename a branch locally and remotely
```
git branch -m old_branch new_branch         # Rename branch locally
git push origin :old_branch                 # Delete the old branch
git push --set-upstream origin new_branch   # Push the new branch, set local branch to track the new remote
```

### Reset
```
git reset --hard HEAD    # to undo all the local uncommitted changes
```

### Syncing a fork (assuming upstreams are set)
```
git fetch upstream
git checkout develop
git merge upstream/develop
```

