#!/bin/bash
set -e
[[ $RUNNER_DEBUG != 1 ]] || set -x

# https://cli.github.com/manual/gh_auth_setup-git
export GH_TOKEN=$INPUT_TOKEN
gh auth setup-git -h "${INPUT_GITHUB_SERVER_URL#*//}"

# https://betterdev.blog/minimal-safe-bash-script-template/
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' SIGINT SIGTERM ERR EXIT

# https://weblog.west-wind.com/posts/2023/Jan/05/Fix-that-damn-Git-Unsafe-Repository
git config --global --add safe.directory "$tmp_dir"

git clone "$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY.wiki.git" "$tmp_dir" --depth 1

# Hidden files (like .myfile.txt, .git/, or .gitignore) are NOT copied.
# The magic "${var:?}" makes it error if the var is zero-length/null.
rm -rf "${tmp_dir:?}"/*
cp -afv "$INPUT_PATH"/* "$tmp_dir"

cd "$tmp_dir"

git config user.name github-actions[bot]
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'

git add -Av
git commit --allow-empty -m 'Deploy wiki'

git push origin master

echo "wiki-url=$INPUT_GITHUB_SERVER_URL/$INPUT_REPOSITORY/wiki" >> "$GITHUB_OUTPUT"
