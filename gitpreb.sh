# remote branch 
git fetch -p

# rebase from current branch
git br -vv
git pull --rebase origin dev
git br -vv

# get current branch name
currentBranch=$(git br | grep -E "^\*" | sed 's/* //g')
echo "currentBranch : $currentBranch"

# rebase from dev branch
git sw dev
git pull --rebase
git br -vv

# switch current branch
git sw $currentBranch
git br -vv
