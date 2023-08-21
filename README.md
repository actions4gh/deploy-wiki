# Upload wiki

📥 Upload your GitHub wiki

<p align=center>
  <img width=400 src="https://i.imgur.com/zmGjnFI.png">
</p>

🤝 Counterpart to [TBD/download-wiki] \
🔁 Works great for bidirectional source ↔ wiki sync

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

**🚀 Here's what you're after:**

```yml
name: Publish wiki
on:
  push:
    branches: "main"
    paths:
      - wiki/**
      - .github/workflows/publish-wiki.yml
concurrency:
  group: ${{ github.workflow }}
  cancel-in-progress: true
jobs:
  publish-wiki:
    concurrency: wiki-write
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: TBD/configure-wiki@v1
        with:
          path: wiki
      - uses: TBD/upload-wiki@v1
        with:
          path: wiki
```

### Inputs

- **`server-url`:** The URL of the server. Usually `https://github.com`, but can
  be changed if you're using cross-instances. Defaults to the
  `github.server_url`.

- **`repository`:** The `user/repo` slug of the repository. Defaults to
  `github.repository` which is usually what you want. This is the repo from
  which the `https://github.com/${repo}/wiki` tab will be downloaded from.

- **`token`:** The authentication token. You don't need this unless you're
  pulling from a different repository that's private and needs a token.

- **`path`:** The specified path. This is where the wiki will be downloaded to.
  Defaults to `.` which is the current directory. You might want to make this
  `wiki` or some other subfolder.

- **`delete`:** Whether or not to delete files that are in the destination (the
  `path` input) but aren't present in the wiki. This is useful for syncing a
  wiki to a local folder. Default is `true`.

## Outputs

- **`wiki-git-url`:** The URL of the wiki's [Gollum] Git repository. Use this if
  you need to do anything else with said Git repository. Usually it's something
  like `https://github.com/user/repo.wiki.git`.

<!-- prettier-ignore-start -->
[gollum]: https://github.com/gollum/gollum
<!-- prettier-ignore-end -->
