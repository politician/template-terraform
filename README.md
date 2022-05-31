# USING THIS TEMPLATE

1. Search/replace for these variables:

   - `{{repo_user}}` (GitHub repo username)
   - `{{repo_name}}` (GitHub repo name)
   - `{{project_name}}` (Project name)
   - `{{security_email}}` (Email to send vulnerabilities with `-noreply` somewhere)

## GitHub Actions

Some GitHub Actions bundled in this template require a personal access token (PAT). This can be sourced either from an app (recommended) or from a user.

### From an app

1. Create an app [with the minimum permissions](https://github.com/settings/apps/new?&name=-bot&description=Bot%20account&url=https%3A%2F%2Fwww.github.com&user_token_expiration_enabled=true&webhook_active=false&contents=write&pull_requests=read) or add the following permissions to an existing app:

    - **Contents**: Read and write
    - **Pull requests**: Read-only

2. Set the `GH_APP_ID` and `GH_APP_PRIVATE_KEY` repo secrets.

### From a user

1. [Create a personal access token](https://github.com/settings/tokens/new?scopes=repo) with the `repo` permissions.

2. Set the `GH_PERSONAL_TOKEN` repo secret.

3. Look into each file in [.github/workflows](.github/workflows):
    - Remove every step called `Generate app token`
    - Replace `${{ steps.generate_token.outputs.token }}` with `${{ secrets.GH_PERSONAL_TOKEN }}`
