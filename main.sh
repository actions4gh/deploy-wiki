#!/bin/bash
set -ex

export GITHUB_TOKEN="$INPUT_TOKEN"
export GITHUB_SERVER_URL="$INPUT_GITHUB_SERVER_URL"
export GITHUB_REPOSITORY="$INPUT_REPOSITORY"

export GH_TOKEN=$GITHUB_TOKEN
export GH_HOST="${GITHUB_SERVER_URL#*//}"
gh auth setup-git

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' SIGINT SIGTERM ERR EXIT
git config --global --add safe.directory "$tmp_dir"
git clone "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.wiki.git" "$tmp_dir"
rsync -avI --delete --exclude=.git "$INPUT_PATH/" "$tmp_dir/"
pushd "$tmp_dir"

git config user.name github-actions[bot]
git config user.email 41898282+github-actions[bot]@users.noreply.github.com
echo "$INPUT_IGNORE" >>.git/info/exclude
git add -Av
git commit --allow-empty -m "$INPUT_COMMIT_MESSAGE"
git push -f origin master

echo "wiki_url=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/wiki" >>"$GITHUB_OUTPUT"
