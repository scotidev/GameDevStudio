#!/bin/bash
# Validates asset files in two modes:
# 1) Claude/Copilot JSON hook mode (stdin contains tool_input.file_path)
# 2) Native git post-commit hook mode (no stdin payload, inspect latest commit)
# Exit 0 = success (non-blocking)

INPUT=$(cat)
WARNINGS=""
FILE_LIST=""

if [ -n "$INPUT" ]; then
    # Parse single file path from JSON payload -- use jq if available, fall back to grep
    if command -v jq >/dev/null 2>&1; then
        FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    else
        FILE_PATH=$(echo "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
    fi

    # Normalize path separators (Windows backslash to forward slash)
    FILE_PATH=$(echo "$FILE_PATH" | sed 's|\\|/|g')
    FILE_LIST="$FILE_PATH"
else
    # Native git hook mode: validate assets touched by latest commit.
    FILE_LIST=$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null | sed 's|\\|/|g' | grep -E '(^|/)assets/' || true)
fi

if [ -z "$FILE_LIST" ]; then
    exit 0
fi

while IFS= read -r FILE_PATH; do
    [ -z "$FILE_PATH" ] && continue

    FILENAME=$(basename "$FILE_PATH")

    # Check naming convention (lowercase with underscores only) -- uses grep -E instead of grep -P
    if echo "$FILENAME" | grep -qE '[A-Z[:space:]-]'; then
        WARNINGS="$WARNINGS\nNAMING: $FILE_PATH must be lowercase with underscores (got: $FILENAME)"
    fi

    # Check JSON validity for data files
    if echo "$FILE_PATH" | grep -qE '(^|/)assets/data/.*\.json$'; then
        if [ -f "$FILE_PATH" ]; then
            # Find a working Python command
            PYTHON_CMD=""
            for cmd in python python3 py; do
                if command -v "$cmd" >/dev/null 2>&1; then
                    PYTHON_CMD="$cmd"
                    break
                fi
            done

            if [ -n "$PYTHON_CMD" ]; then
                if ! "$PYTHON_CMD" -m json.tool "$FILE_PATH" > /dev/null 2>&1; then
                    WARNINGS="$WARNINGS\nFORMAT: $FILE_PATH is not valid JSON"
                fi
            fi
        fi
    fi
done <<< "$FILE_LIST"

if [ -n "$WARNINGS" ]; then
    echo -e "=== Asset Validation ===$WARNINGS\n========================" >&2
fi

exit 0
