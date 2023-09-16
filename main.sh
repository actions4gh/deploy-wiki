#!/bin/bash
set -ex

export GH_TOKEN=$INPUT_TOKEN
gh auth setup-git -h "${INPUT_GITHUB_SERVER_URL#*//}"

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' SIGINT SIGTERM ERR EXIT

git config --global --add safe.directory "$tmp_dir"

git clone "$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY.wiki.git" "$tmp_dir"

rm -rf "${tmp_dir:?}"/*
cp -afv "$INPUT_PATH"/* "$tmp_dir/"

cd "$tmp_dir"

[[ -z $GIT_AUTHOR_NAME ]] && export GIT_AUTHOR_NAME="$GITHUB_ACTOR"
[[ -z $GIT_AUTHOR_EMAIL ]] && export GIT_AUTHOR_EMAIL="<$GITHUB_ACTOR@users.noreply.github.com>"

[[ -z $GIT_COMITTER_NAME ]] && export GIT_COMITTER_NAME="github-actions[bot]"
[[ -z $GIT_COMITTER_EMAIL ]] && export GIT_COMITTER_EMAIL="41898282+github-actions[bot]@users.noreply.github.com"

git add -Av
git commit -m 'Deploy wiki'

git push origin master

echo "wiki-url=$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY/wiki" >> "$GITHUB_OUTPUT"
