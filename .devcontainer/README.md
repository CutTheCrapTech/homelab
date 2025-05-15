## DevPod Instructions

Changes if necessary:
1. IMAGE_NAME in [build_dev_container.yaml](/.github/workflows/build_dev_container.yaml).
2. Features in [devcontainer.json image builder](/.github/.devcontainer/devcontainer.json).
3. Image in [devcontainer.json](/.devcontainer/devcontainer.json).
4. DevPod link below, to your liking. Note: workspace property below doesn't as of now. [Open Issue](https://github.com/loft-sh/devpod/issues/1843).
5. Create docker/k8s provider in DevPod app. Change settings to your liking.

[![Open in DevPod!](https://devpod.sh/assets/open-in-devpod.svg)](https://devpod.sh/open#git@github.com:karteekiitg/homelab.git@prod&workspace=my-k8s-workspace&provider=docker&ide=zed)

Note: Suggest to use original image (i.e no need to change step 1,2 and 3) to reduce complexity, unless you have a specific reason to use a different image. When you do have a valid reason not to,that you think benefits others, raise a Issue/PR.

Note: By default, tries to load `.env` from the project root and `.devcontainer/infisical_secrets.env` to the environment variables in the devcontainer.

## Infisical Setup (Optional)
If using Infisical to manage secrets, you'll need to provide your Infisical Client Secret. Follow below instructions:

1.  **Prepare the Infisical Secrets File**:
    Run the following command in your terminal at the root of the `homelab` project by replacing "<your_infisical_client_secret>" with your actual infisical secret.
    ```shell
    LINE_TO_ADD='TF_VAR_infisical_client_secret="<your_infisical_client_secret>"' # Note: Change this
    SECRETS_FILE=".devcontainer/infisical_secrets.env"

    # Check if the file already contains a line for the secret.
    # We use a general grep for "TF_VAR_infisical_client_secret" to avoid adding duplicates
    # if the user has already manually created/edited the line.
    # The 2>/dev/null suppresses "No such file or directory" from grep if $SECRETS_FILE doesn't exist.
    if ! grep -Fq "TF_VAR_infisical_client_secret" "$SECRETS_FILE" 2>/dev/null; then
      echo "$LINE_TO_ADD" >> "$SECRETS_FILE"
      echo "Added TF_VAR_infisical_client_secret to '$SECRETS_FILE'."
    else
      echo "TF_VAR_infisical_client_secret line already exists in '$SECRETS_FILE'."
    fi
    ```

2.  **Security Note**:
    The file `.devcontainer/infisical_secrets.env` is covered by the `*secrets*.env` pattern in `.gitignore` and will **not** be committed to your repository.

3.  **Activate Changes**:
    Now source your Zsh configuration. This ensures the Infisical setup script (which reads `.devcontainer/infisical_secrets.env`) is executed:
    ```shell
    source ~/.zshrc
    ```

If you want to get all your other Infisical secrets into your devcontainer environment automatically (beyond just the client secret), ensure `homelab/.env` is also set up correctly with your Infisical project details (domain, project ID, path, etc.). The `setup_infisical.sh` script, orchestrated by `customize_zsh.sh` (which modifies `.zshrc`), will then use these details to fetch and export secrets into your shell.

## GCloud Cli Setup (Optional)
Run the below commands to setup gcloud cli in your devpod workspace
```shell
gcloud auth application-default login --no-launch-browser
```

### Issues
Currently few bugs are reported in DevPod.
1. [Deeplink](https://github.com/loft-sh/devpod/issues/1843) doesn't work as it is supposed to. So workspace name is not auto-filled.

TODO: Look into how PVs and multiple workspaces work.
