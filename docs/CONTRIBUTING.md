# Contributing

🎉 Thank you for taking the time to contribute to {{project_name}} 🎉

The following is a set of guidelines for contributing.
These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

**Here are four ways you can contribute:**

1. [Spread the word](#spread-the-word)
2. [Report bugs](#report-bugs)
3. [Improve the documentation](#improve-the-documentation)
4. [Resolve issues and implement new features](#resolve-issues-and-features)

## Spread the Word

- The easiest to show your support: **Star {{project_name}}** on GitHub.

- You can bring up {{project_name}} in a conversation at the coffee machine, [Reddit](https://www.reddit.com/submit?url=https://github.com/{{repo_owner}}/{{repo_name}}), [Twitter](https://twitter.com/intent/tweet?url=https://github.com/{{repo_owner}}/{{repo_name}}), [LinkedIn](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/{{repo_owner}}/{{repo_name}}), [Facebook](https://www.facebook.com/sharer/sharer.php?u=https://github.com/{{repo_owner}}/{{repo_name}}), etc.

- {{project_name}} and how you use it can be a good subject for an article if you are into blogging.

## Report Bugs

If you found a bug, thank you for taking the time to report it 🙏

To do so, please [open an issue](https://github.com/{{repo_owner}}/{{repo_name}}/issues/new) and give as much information as you can about the bug you found and how to reproduce it.

If you **know** this is a quick fix, you can apply the labels `good first issue` and `easy` so new contributors can find it easily to resolve it.

> ⚠️ If you found a vulnerability, please see [our security policy](SECURITY.md)

## Improve the Documentation

We welcome improvements to the documentation.

If you want to fix a typo, add a sentence or two, an example, etc., you can open a pull request directly.

For bigger changes to the documentation, we recommend to discuss it in an issue before spending any time making huge changes that could be rejected.

## Resolve Issues and Features

If you are into coding, you can **resolve issues** or **implement new features**.

New contributors should look for issues [labelled **good first issue** or **easy**](https://github.com/{{repo_owner}}/{{repo_name}}/issues?q=is%3Aopen+label%3A"good+first+issue",easy).

> ⚠️ Before you start coding, please **first discuss** the change you wish to make by commenting on an existing issue or by [opening an issue](https://github.com/{{repo_owner}}/{{repo_name}}/issues/new).

### Pull Request Process

1. [Fork this repository](https://github.com/{{repo_owner}}/{{repo_name}}/fork).

2. Clone **your fork** on your workstation.

3. Setup the developer dependencies (listed in [Brewfile](https://github.com/{{repo_owner}}/{{repo_name}}/blob/main/Brewfile) and [package.json](https://github.com/{{repo_owner}}/{{repo_name}}/blob/main/package.json)):

   ```sh
   make setup
   ```

4. Create a branch named after the feature or bug you're working on:

   ```sh
   git switch -c <branch_name>
   ```

5. Write code and tests for your change then commit them to your working branch and push them to your repository:

   ```sh
   git add .
   git commit
   git push origin <branch_name>
   ```

   > ⚠️ We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification in order to benefit from a proper semantic versioning and an auto-generated changelog. Please familiarize yourself with the spec before you commit.

6. [Open a pull request](https://github.com/{{repo_owner}}/{{repo_name}}/compare) against this project

7. Wait for your pull request to be merged and watch it to answer any questions or make any changes you're asked. You will make these modifications directly on your working branch.

8. The project maintainers may ask you to rebase your branch. You can do it **either**:

   - From your pull request by commenting `/rebase`
   - From your workstation:

     ```sh
     git remote add upstream git@github.com:{{repo_owner}}/{{repo_name}}.git
     git switch <branch_name>
     git fetch upstream
     git rebase upstream/main
     git push --force origin <branch_name>
     ```

9. Once it is merged, you can delete your working branch

   ```sh
   git checkout main
   git branch -d <branch_name>
   git push origin --delete <branch_name>
   ```

## Code of Conduct

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-informational.svg?style=flat-square)](CODE_OF_CONDUCT.md)

For all your interactions with {{project_name}}, you must adhere to our [code of conduct](CODE_OF_CONDUCT.md). We adopted the [Contributor Covenant](https://www.contributor-covenant.org/) which has been adopted by many popular open source projects.

## License

[![Apache 2.0 license](https://img.shields.io/badge/License-Apache--2.0-informational?style=flat-square)](https://www.apache.org/licenses/LICENSE-2.0)

By contributing to this project, you agree to license your contribution under the terms of our [license](/LICENSE.md).
