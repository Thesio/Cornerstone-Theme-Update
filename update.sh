#!/bin/bash
SOURCE_BRANCH="automated/template/latest-release"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/bigcommerce/cornerstone/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3)}')
echo "$LATEST_RELEASE"
git remote add upstream https://github.com/bigcommerce/cornerstone.git
git fetch upstream
git checkout -f develop
rm -rf package-lock.json
GITIGNORE=$(<.gitignore)
CONFIGJSON=$(<config.json)
git branch -D "$SOURCE_BRANCH"
git push origin --delete "$SOURCE_BRANCH"
git checkout -b "$SOURCE_BRANCH"
git merge -X theirs tags/"$LATEST_RELEASE" --allow-unrelated-histories --no-commit
git restore --source=HEAD --staged --worktree  -- .github/
git restore --source=HEAD --staged  -- .gitignore
git restore --source=HEAD --staged  -- package-lock.json
git restore --source=HEAD --staged  -- config.json
echo "$GITIGNORE" > '.gitignore'
echo "$CONFIGJSON" > 'config.json'
git add .gitignore
git add config.json
git commit -m "merged tags/$LATEST_RELEASE to $SOURCE_BRANCH"
git push origin "$SOURCE_BRANCH"
