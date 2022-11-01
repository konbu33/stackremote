# remote branch 
git fetch -p

# rebase from current branch
git br -vv
git pull --rebase origin dev
git br -vv

# rebase from dev branch
git sw dev
git pull --rebase
git br -vv

