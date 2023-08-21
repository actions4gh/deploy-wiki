#!/bin/bash
set -ex

export GH_TOKEN=$INPUT_TOKEN
export GH_HOST=${INPUT_SERVER_URL#*//}
gh auth setup-git

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' SIGINT SIGTERM ERR EXIT
git config --global --add safe.directory "$tmp_dir"

wiki_git_url="$INPUT_SERVER_URL/$INPUT_REPOSITORY.wiki.git"
git clone "$wiki_git_url" "$tmp_dir"

if [[ $INPUT_DELETE == true ]]; then
  rm -rf "$tmp_dir"/*
fi
cp -afv "$INPUT_PATH"/* "$tmp_dir/"

[[ -z $GIT_AUTHOR_NAME ]] && export GIT_AUTHOR_NAME="$GITHUB_ACTOR"
[[ -z $GIT_AUTHOR_EMAIL ]] && export GIT_AUTHOR_EMAIL="<$GITHUB_ACTOR@users.noreply.github.com>"
[[ -z $GIT_COMITTER_NAME ]] && export GIT_COMITTER_NAME="github-actions[bot]"
[[ -z $GIT_COMITTER_EMAIL ]] && export GIT_COMITTER_EMAIL="41898282+github-actions[bot]@users.noreply.github.com"
git add -Av
git commit -m 'Apply wiki changes'
git push -f origin master

echo "wiki-git-url=$wiki_git_url" >>$GITHUB_OUTPUT
