# Deploy GitHub wiki

🚀 GitHub Action to publish files to a GitHub wiki for deployments

<p align=center>
  <img width=500 src="https://i.imgur.com/OrKe4FR.png">
</p>

⬆️ Uploads a bunch of files to a repository's wiki \
📚 Works great for documentation \
🔀 Allows contributors to open Pull Requests for wiki content \
🤝 Complimented by [actions4gh/configure-wiki]

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

**🚀 Here's what you're after:**

```yml
# .github/workflows/deploy-wiki.yml
name: deploy-wiki
on:
  push:
    branches: "main"
    paths: wiki/**
jobs:
  deploy-wiki:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions4gh/configure-wiki@v1
      - uses: actions4gh/deploy-wiki@v1
```

👆 This GitHub workflow will deploy the wiki content from `wiki/` (can be changed with the `path` input) to the GitHub wiki tab for the current repository.

### Inputs

- **`github-server-url`:** The base URL for the GitHub instance that you are
  trying to clone from, will use environment defaults to fetch from the same
  instance that the workflow is running from unless specified. Example URLs are
  `https://github.com` or `https://my-ghes-server.example.com`. The default is
  `github.server_url`. It's unlikely you need to change this unless you are
  deploying _across_ a GHES boundary.

- **`repository`:** The repository slug to use as the base project target of the
  wiki. The contents will be deployed to this repository's wiki tab, not the
  repository itself. Use this if you are pushing contents across the repository
  boundary. Defaults to the current repository from `github.repository`.

- **`token`:** Set this if you are pushing to a different repository. This token
  will need write permissions. The default is `github.token`.

- **`path`:** Path of the directory containing the wiki files to be deployed.
  Defaults to the `wiki/` folder.

### Outputs

- **`wiki-url`:** The URL of the published GitHub wiki hompage. Usually
  something like `https://github.com/octocat/project/wiki`.

### Bidirectional wiki sync

Sometimes you want two-way wiki sync so that edits from the repository are reflected
in the wiki and edits from the wiki are committed to the repository. You've seen above how to go from the source repository to the wiki tab. Here's a complete demo using [actions4gh/download-wiki] to perform the reverse of downloading the wiki content and commiting it to the source repository.

```yml
# .github/workflows/sync-wiki.yml
name: Sync wiki
on:
  push:
    branches: "main"
    paths: wiki/**
  gollum:
  schedule:
    - cron: "8 14 * * *"
jobs:
  deploy-wiki:
    if: github.event_name == 'push'
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions4gh/configure-wiki@v1
      - uses: actions4gh/deploy-wiki@v1
  checkout-wiki:
    if: github.event_name != 'push'
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: rm -rf wiki
      - uses: actions4gh/download-wiki@v1
        with:
          path: wiki
      - uses: actions4gh/configure-wiki/reverse@v1
      - uses: stefanzweifel/git-auto-commit-action@v5
```

Check out the [actions4gh/download-wiki] action to learn more about what inputs
are available and learn more about using it.

### Pushing to another repository's wiki

If you want to push the contents of octocat/wiki to octocat/project, then you'll
first need a GitHub Personal Access Token with permission to write the contents
of the destination repository. In this example, that's octocat/project. Then you
can use this action like this:

```yml
- uses: actions4gh/deploy-wiki@v1
  with:
    repository: octocat/project
    token: ${{ secrets.MY_TOKEN }}
```

[actions/configure-pages]: https://github.com/actions/configure-pages
[actions4gh/configure-wiki]: https://github.com/actions/configure-wiki
[actions4gh/download-wiki]: https://github.com/actions/download-wiki
