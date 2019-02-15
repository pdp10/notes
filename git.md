# Git


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

