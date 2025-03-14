#!/bin/bash

# Detect the script's directory (base directory)
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect the operating system
OS_NAME="$(uname -s)"

case "$OS_NAME" in
Linux*) OS_FOLDER="linux" ;;
Darwin*) OS_FOLDER="macos" ;;                    # macOS is identified as Darwin
CYGWIN* | MINGW* | MSYS*) OS_FOLDER="windows" ;; # Windows (Git Bash, Cygwin, MSYS)
*)
  echo "Unsupported OS: $OS_NAME"
  exit 1
  ;;
esac

# Set OS-specific directory
OS_DIR="$BASE_DIR/$OS_FOLDER"
mkdir -p "$OS_DIR"

# Move to the Git repository
cd "$BASE_DIR" || exit 1

# Verify it's a Git repo
if [ ! -d ".git" ]; then
  echo "Error: Not a Git repository. Initialize or clone a Git repo here."
  exit 1
fi

# Export Conda environment
conda env export >"$OS_DIR/environment.yml"

# Export installed Conda packages
conda list --explicit >"$OS_DIR/conda_list.txt"

# Export pip packages
pip freeze >"$OS_DIR/pip_requirements.txt"

# Commit and push to GitHub
git add "$OS_DIR/environment.yml" "$OS_DIR/conda_list.txt" "$OS_DIR/pip_requirements.txt"
git commit -m "Auto backup for $OS_FOLDER: $(date)"
git push
