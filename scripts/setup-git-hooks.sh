#!/bin/bash
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [ -z "${REPO_ROOT}" ]; then
  echo "ERROR: Not inside a git repository." >&2
  exit 1
fi

SOURCE_DIR="${REPO_ROOT}/.githooks"
TARGET_DIR="${REPO_ROOT}/.git/hooks"

if [ ! -d "${SOURCE_DIR}" ]; then
  echo "ERROR: Missing ${SOURCE_DIR}" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

for hook in pre-commit pre-push post-commit; do
  if [ ! -f "${SOURCE_DIR}/${hook}" ]; then
    echo "ERROR: Missing hook template ${SOURCE_DIR}/${hook}" >&2
    exit 1
  fi

  cp "${SOURCE_DIR}/${hook}" "${TARGET_DIR}/${hook}"
  chmod +x "${TARGET_DIR}/${hook}" || true
  echo "Installed ${hook}"
done

echo "Git hooks installed successfully."
echo "Tip: run 'git commit --allow-empty -m \"hook smoke test\"' to verify pre-commit."
