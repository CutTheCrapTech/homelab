#!/bin/bash

# Get the workdir from the first argument
WRK_DIR="$1"

# Get the zshrc file path from the second argument
ZSHRC_FILE_PATH="$2"

ENV_FILE_PATH=$WRK_DIR/.env
INFISICAL_FILE_PATH=$WRK_DIR/.devcontainer/setup_infisical.sh
HOOKS_DIR_PATH=$WRK_DIR/hooks

if [ -f "$ENV_FILE_PATH" ]; then
  cat <<EOF >> "$ZSHRC_FILE_PATH"

  # Set Environment Variables
  set -a
  source "$ENV_FILE_PATH"
  set +a

EOF
else
  echo "Warning: Environment file not found at: $ENV_FILE_PATH"
fi

if [ -f "$INFISICAL_FILE_PATH" ]; then
  cat <<EOF >> "$ZSHRC_FILE_PATH"
  # Run Infisical Script and set environment variables
  chmod +x $WRK_DIR/.devcontainer/setup_infisical.sh
  $WRK_DIR/.devcontainer/setup_infisical.sh

  if [ -f "/tmp/.env" ]; then
    source /tmp/.env
  fi

EOF
else
    echo "Infisical Script not found at: $INFISICAL_FILE_PATH"
fi

if [ -d "$HOOKS_DIR_PATH" ]; then
  cat <<EOF >> "$ZSHRC_FILE_PATH"
  # Set Git Hooks Path
  git config --local core.hooksPath "$HOOKS_DIR_PATH"

EOF
else
    echo "Git hooks not found."
fi

cat <<EOF >> "$ZSHRC_FILE_PATH"
# Set Git Branch
export GIT_BRANCH=$(git symbolic-ref --short HEAD)

EOF
