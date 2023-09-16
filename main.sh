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

git config user.name github-actions[bot]
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'

git add -Av
git commit -m 'Deploy wiki'

git push origin master

echo "wiki-url=$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY/wiki" >> "$GITHUB_OUTPUT"
