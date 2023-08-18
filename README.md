# Upload to GitHub wiki

⬆️ Upload a folder to your GitHub wiki

<p align=center>
  <img width=400 src="https://i.imgur.com/yFH4WBP.png">
</p>

📂 Keep your dev docs in sync with your code \
🔁 Able to open PRs with docs updates \
✨ Use the fancy GitHub wiki reader UI

## Usage

![GitHub Actions](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub+Actions&color=2088FF&logo=GitHub+Actions&logoColor=FFFFFF&label=)
![GitHub](https://img.shields.io/static/v1?style=for-the-badge&message=GitHub&color=181717&logo=GitHub&logoColor=FFFFFF&label=)

**🚀 Here's what you're after:**

```yml
name: Publish wiki
on:
  push:
    branches: "main"
jobs:
  publish-wiki:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: tj-actions/links-strip-ext@v1
      - uses: tj-actions/upload-wiki@v1
```

☝ This workflow will publish the `wiki/` folder from your GitHub repository to
the `.wiki.git` [Gollum] repository that backs the <kbd>Wiki</kbd> GitHub tab.

<details><summary>If you're after something more advanced, here's an example that pushes <em>across a repository boundary</em>...</summary>

```yml
on:
  push:
    branches: "main"
jobs:
  publish-wiki:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: tj-actions/links-strip-ext@v1
      - uses: tj-actions/upload-wiki@v1
        with:
          token: ${{ secrets.MEGA_PROJECT_GITHUB_TOKEN }}
          repository: octocat/mega-project
          path: .
```

ℹ You will need a GitHub access token with permission to write to the target
repository.

</details>

<img align=right src="https://i.imgur.com/ABKIS4h.png" />

⚠️ You must create a dummy page manually! This is what initially creates the
backing Gollum Git repository which needs to exist to push to. 🤷‍♀️

💡 Each page has an auto-generated title. It is derived from the filename by
replacing every `-` (dash) character with a space. Name your files accordingly.
The `Home.md` file will automatically become the homepage, not `README.md`. This
is specific to GitHub wikis.

For extra bonus points you can use [tj-actions/download-wiki] and then push the
contents back to the `wiki/` folder!

</details>

### Inputs

TODO: Fill this out

### Outputs

- **`wiki_url`:** The HTTP URL that points to the deployed repository's wiki
  tab. This is essentially the concatenation of `${{ github.server_url }}`,
  `${{ github.repository }}`, and the `/wiki` page.

<!-- prettier-ignore-start -->
[gollum]: https://github.com/gollum/gollum
[tj-actions/download-wiki]: https://github.com/tj-actions/download-wiki
<!-- prettier-ignore-end -->
