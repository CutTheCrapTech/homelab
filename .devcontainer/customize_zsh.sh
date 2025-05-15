#!/bin/bash

# Get the workdir from the first argument
WRK_DIR="$1"

# Get the zshrc file path from the second argument
ZSHRC_FILE_PATH="$2"

ENV_FILE_PATH=$WRK_DIR/.env
INFISICAL_FILE_PATH=$WRK_DIR/.devcontainer/setup_infisical.sh
HOOKS_DIR_PATH=$WRK_DIR/hooks

cat <<EOF >> "$ZSHRC_FILE_PATH"

# Set Environment Variables from $ENV_FILE_PATH
if [ -f "$ENV_FILE_PATH" ]; then
  set -a
  . "$ENV_FILE_PATH"
  set +a
else
  echo "Warning: Environment file not found at: $ENV_FILE_PATH. Some environment variables may be missing."
fi
EOF

INFISICAL_CLIENT_SECRET_FILE_PATH="$WRK_DIR/.devcontainer/infisical_secrets.env"
cat <<EOF >> "$ZSHRC_FILE_PATH"

# Source local Infisical client secret if it exists when .zshrc is loaded
if [ -f "$INFISICAL_CLIENT_SECRET_FILE_PATH" ]; then
  echo "Sourcing Infisical client secret from $INFISICAL_CLIENT_SECRET_FILE_PATH for the current shell"
  set -a
  . "$INFISICAL_CLIENT_SECRET_FILE_PATH" # Using . is equivalent to source and more portable
  set +a
else
  echo "Warning: Infisical client secret file not found at: $INFISICAL_CLIENT_SECRET_FILE_PATH. TF_VAR_infisical_client_secret may not be set."
fi
EOF

cat <<EOF >> "$ZSHRC_FILE_PATH"

# Run Infisical Script and set environment variables if $INFISICAL_FILE_PATH exists
if [ -f "$INFISICAL_FILE_PATH" ]; then
  chmod +x "$INFISICAL_FILE_PATH"
  "$INFISICAL_FILE_PATH"

  if [ -f "/tmp/.env" ]; then
    . "/tmp/.env" # Using . is equivalent to source
  fi
else
  echo "Warning: Infisical setup script not found at: $INFISICAL_FILE_PATH. Infisical secrets might not be loaded."
fi
EOF

cat <<EOF >> "$ZSHRC_FILE_PATH"

# Set Git Hooks Path if $HOOKS_DIR_PATH exists
if [ -d "$HOOKS_DIR_PATH" ]; then
  git config --local core.hooksPath "$HOOKS_DIR_PATH"
else
  echo "Warning: Git hooks directory not found at: $HOOKS_DIR_PATH. Custom git hooks may not be active."
fi
EOF

cat <<EOF >> "$ZSHRC_FILE_PATH"
# Set Git Branch
export GIT_BRANCH=$(git symbolic-ref --short HEAD)

EOF
