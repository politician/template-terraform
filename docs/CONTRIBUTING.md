# Contributing

👍🎉 First off, thank you for taking the time to contribute to {{project_name}}! 🎉👍

The following is a set of guidelines for contributing.
These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

Please follow our [code of conduct](CODE_OF_CONDUCT.md) in all your interactions with {{project_name}}.

## Many ways to contribute

1. [Spread the Word](#spread-the-word)
2. [Report Bugs](#report-bugs)
3. [Resolve Issues](#resolve-issues)
4. [Improve the Documentation](#improve-the-documentation)

### Spread the Word

If you like {{project_name}}, you can bring it up in a conversation at the coffee machine with your colleagues, on an internet forum, Reddit, Quora, Linkedin, etc.

If you own a blog or are thinking of starting one, {{project_name}} and how you use it might be a good subject for an article.

If you are using {{project_name}} in one way or another, credits are always welcome.

### Report Bugs

If you found a bug, thank you for taking the time to report it 🙏
To do so, just [open an issue](https://github.com/{{repo_owner}}/{{repo_name}}/issues/new?template=bug_report.yaml) and give as much information as you can about the bug you found and how to reproduce it.

If you know this is a quick fix, you can apply the labels `good first issue` and `easy` so programmers new to {{project_name}} can find it easily to resolve it.

> ⚠️ If you found a vulnerability, please see [our security policy](SECURITY.md)

### Resolve Issues

If this is your first time contributing to {{project_name}}, we recommend that you [look for issues](https://github.com/{{repo_owner}}/{{repo_name}}/issues?q=is%3Aopen+label%3A"good+first+issue"+label%3A"easy") labelled **good first issue** or **easy**.

Before coding your pull request, please first discuss the change you wish to make by commenting on an existing issue or by opening an issue.

#### Pull Request Process

We follow the [GitHub Flow](https://guides.github.com/introduction/flow/).

[![alt text](img/gitflow.png "GitHub Flow")](https://guides.github.com/pdfs/githubflow-online.pdf)

Here is the process:

1. [Fork this repository](https://github.com/{{repo_owner}}/{{repo_name}}/fork)

2. Clone **your** fork on your workstation

3. Most of the time, you will want to create a branch off the `main` branch which should be checked out by default, you can ensure it by running:

   ```sh
   git checkout main
   ```

4. Create a branch named after the feature you're working on

   ```sh
   git switch -c <branch_name>
   ```

5. Write code and tests for your change then commit them to your branch and push them to your repository.

   ```sh
   git add .
   git commit
   git push origin <branch_name>
   ```

   > How to write a descriptive commit message:
   >
   > - Describe what was done; not the result
   > - Use the active voice
   > - Use the present tense
   > - Capitalize properly
   > - Do not end in a period — this is a title/subject
   > - Prefix the subject with its scope

6. Open a pull request against this project

7. Work with the project maintainer(s) to get your pull request reviewed

8. Wait for your pull request to be merged and watch it to answer any questions or make any changes you're asked. You will make these modifications directly on your feature branch.

9. Once it is merged, you can delete your feature branch

   ```sh
   git checkout main
   git branch -d <branch_name>
   git push origin --delete <branch_name>
   ```

### Improve the Documentation

We also welcome improvements to the documentation. If you want to fix a typo, add a sentence or two, an example, etc. we recommend that you open a pull request directly. For bigger changes to the documentation, we recommend to discuss it in an issue before spending any time making huge changes that could be rejected.

## License

By contributing your code, you agree to license your contribution under the terms of our [LICENSE.md](https://github.com/{{repo_owner}}/{{repo_name}}/blob/main/LICENSE.md)

## Code of Conduct

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg?style=flat-square)](CODE_OF_CONDUCT.md)

We adopted the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct for {{project_name}}.
