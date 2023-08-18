#!/bin/bash
set -ex

export GITHUB_TOKEN="$INPUT_TOKEN"
export GITHUB_SERVER_URL="$INPUT_GITHUB_SERVER_URL"
export GITHUB_REPOSITORY="$INPUT_REPOSITORY"

export GIT_DIR && GIT_DIR=$(mktemp -d)
export GIT_WORK_TREE=$INPUT_PATH
trap 'rm -rf "$GIT_DIR"' SIGINT SIGTERM ERR EXIT

export GH_TOKEN=$GITHUB_TOKEN
export GH_HOST="${GITHUB_SERVER_URL#*//}"
gh auth setup-git
git config --global --add safe.directory "$GIT_DIR"

git clone "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.wiki.git" "$GIT_DIR" --bare
git config --unset core.bare

echo "$INPUT_IGNORE" >>"$GIT_DIR/info/exclude"
git add -Av

git config user.name github-actions[bot]
git config user.email 41898282+github-actions[bot]@users.noreply.github.com

git commit --allow-empty -m "$INPUT_COMMIT_MESSAGE"
git push -f origin master

echo "wiki_url=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/wiki" >>"$GITHUB_OUTPUT"
