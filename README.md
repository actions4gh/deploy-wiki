# Deploy GitHub wiki

🚀 GitHub Action to publish files to a GitHub wiki for deployments

<p align=center>
  <img width=400 src="https://i.imgur.com/jgelXnU.png">
</p>

⬆️ Uploads a bunch of files to a repository's wiki \
📚 Works great for documentation

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

**🚀 Here's what you're after:**

```yml
name: Deploy wiki
on:
  push:
    branches: "main"
    paths:
      - my-docs/**
jobs:
  deploy-wiki:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions4gh/deploy-wiki@v1
        with:
          path: my-docs
```

This GitHub Action deploys the content found in the specified `path` (`wiki/` by
default) to the GitHub wiki.

<details><summary>Fix wiki links</summary>

By default this Action doesn't do any editing of your wiki content. This can be
seen with links like `./My-page.md` which will work in the normal GitHub source
code viewer but not on the deployed wiki. Why? Because source code links use the
complete file name including the extension and wiki links strip the extension.
To get the link to work on the wiki page you'd need to use `./My-page` with no
`.md` extension.

Similar to the [actions/configure-pages] action, there's an
[actions4gh/configure-wiki] action to edit your workspace just a bit and
preconfigure your Markdown files for deployment to the GitHub wiki.

```yml
- uses: actions4gh/configure-wiki@v1
  with:
    path: my-docs
- uses: actions4gh/deploy-wiki@v1
  with:
    path: my-docs
```

</details>

<details><summary>Pushing to another repository's wiki</summary>

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

</details>

<details><summary>Using with GitHub Enterprise</summary>

This action automatically makes use of `github.server_url` which is set to your
`https://github.example.com` GitHub server origin. You should still be able to
use the normal GitHub workflow 👆 shown above without any edits. If you want to
push _across_ the GitHub instance boundary, you can use something like this:

```yml
# https://github.com/octocat/wiki => https://github.example.com/octocat/project
# Triggered by push on https://github.com/octocat/wiki
- uses: actions4gh/deploy-wiki@v1
  with:
    github-server-url: https://github.example.com
    repository: octocat/project
    token: ${{ secrets.MY_TOKEN }}
```

</details>

### Inputs

- **`github-server-url`:** The base URL for the GitHub instance that you are
  trying to clone from, will use environment defaults to fetch from the same
  instance that the workflow is running from unless specified. Example URLs are
  `https://github.com` or `https://my-ghes-server.example.com`. The default is
  `github.server_url`.

- **`repository`:** The repository slug to use as the base project target of the
  wiki. The contents will be deployed to this repository's wiki tab, not the
  repository itself. Use this if you are pushing contents across the repository
  boundary. Defaults to the current repository from `github.repository`.

- **`token`:** Set this if you are pushing to a different repository. This token
  will need write permissions. The default is `github.token`.

- **`path`:** Path of the directory containing the wiki files to be deployed.
  Defaults to the `wiki/` folder.

## Outputs

- **`wiki-url`:** The URL of the published GitHub wiki hompage. Usually
  something like https://github.com/octocat/project/wiki.
