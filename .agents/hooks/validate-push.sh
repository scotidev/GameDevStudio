#!/bin/bash
# Validates push intent in two modes:
# 1) Claude/Copilot JSON hook mode (stdin contains tool_input.command)
# 2) Native git pre-push hook mode (no stdin payload, script is invoked directly)
# Exit 0 = allow, Exit 2 = block

INPUT=$(cat)
COMMAND=""

if [ -n "$INPUT" ]; then
    # Parse command -- use jq if available, fall back to grep
    if command -v jq >/dev/null 2>&1; then
        COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
    else
        COMMAND=$(echo "$INPUT" | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//;s/"$//')
    fi

    # If payload exists but is not a push command, skip.
    if ! echo "$COMMAND" | grep -qE '^git[[:space:]]+push'; then
        exit 0
    fi
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
MATCHED_BRANCH=""

# Check if pushing to a protected branch
for branch in develop main master; do
    if [ "$CURRENT_BRANCH" = "$branch" ]; then
        MATCHED_BRANCH="$branch"
        break
    fi
    # Also check if pushing to a protected branch explicitly (quote branch name for safety)
    if echo "$COMMAND" | grep -qE "[[:space:]]${branch}([[:space:]]|$)"; then
        MATCHED_BRANCH="$branch"
        break
    fi
done

if [ -n "$MATCHED_BRANCH" ]; then
    echo "Push to protected branch '$MATCHED_BRANCH' detected." >&2
    echo "Reminder: Ensure build passes, unit tests pass, and no S1/S2 bugs exist." >&2
    # Allow the push but warn -- uncomment below to block instead:
    # echo "BLOCKED: Run tests before pushing to $CURRENT_BRANCH" >&2
    # exit 2
fi

exit 0
