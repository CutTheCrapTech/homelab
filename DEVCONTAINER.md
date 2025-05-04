## DevPod Instructions

Changes if necessary:
1. IMAGE_NAME in [build_dev_container.yaml](.github/workflows/build_dev_container.yaml).
2. Features in [devcontainer.json image builder](.github/.devcontainer/devcontainer.json).
3. Image in [devcontainer.json](.devcontainer/devcontainer.json).
4. DevPod link below, to your liking. Note: workspace property below doesn't as of now. [Open Issue](https://github.com/loft-sh/devpod/issues/1843).
5. Create docker/k8s provider in DevPod app. Change settings to your liking.

[![Open in DevPod!](https://devpod.sh/assets/open-in-devpod.svg)](https://devpod.sh/open#git@github.com:karteekiitg/homelab.git&workspace=my-k8s-workspace&provider=docker&ide=zed)

Note: Suggest to use original image (i.e no need to change step 1,2 and 3) to reduce complexity, unless you have a specific reason to use a different image. When you do have a valid reason not to,that you think benefits others, raise a Issue/PR.

Note: By default, tries to load .env and secrets.env to the environment variables in devcontainer.

## Infisical Setup (Optional)
If using Infisical, run the below code replacing `<your_infisical_client_secret>` with your actual secret, in your devpod workspace, after creating it.
```shell
line_to_add='export TF_VAR_cloud_infisical_client_secret="<your_infisical_client_secret>"'; if ! grep -Fxq "$line_to_add" ~/.zshrc; then echo "$line_to_add" >> ~/.zshrc; echo "Added '$line_to_add' to ~/.zshrc"; else echo "'$line_to_add' already exists in ~/.zshrc"; fi
source ~/.zshrc
```

If you want to get all your infisical secrets into your devcontainer environment automatically, set up .env properly, in addition to the above step.

## GCloud Cli Setup (Optional)
Run the below commands to setup gcloud cli in your devpod workspace
```shell
gcloud auth application-default login --no-launch-browser
```

### Issues
Currently few bugs are reported in DevPod.
1. [Deeplink](https://github.com/loft-sh/devpod/issues/1843) doesn't work as it is supposed to. So workspace name is not auto-filled.

TODO: Look into how PVs and multiple workspaces work.
