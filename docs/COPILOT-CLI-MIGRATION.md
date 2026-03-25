# Copilot CLI Migration Plan and Status

## Objective

Run this repository primarily with Copilot CLI in terminal mode while preserving
collaborative workflow guarantees:

- Question -> Options -> Decision -> Draft -> Approval
- Explicit approval before file writes
- Guardrails for commit/push and data quality checks

## Current Status

### Completed in this phase

1. Introduced git hook wrappers in `.githooks/`:
   - `pre-commit`
   - `pre-push`
   - `post-commit`
2. Added install scripts:
   - `scripts/setup-git-hooks.sh`
   - `scripts/setup-git-hooks.ps1`
3. Updated validation scripts to support dual mode:
   - Runtime JSON payload mode (legacy hooks)
   - Native git hook mode (Copilot CLI path)
4. Updated onboarding docs to point Copilot CLI users to git hook installation.

### Not migrated yet

1. Session lifecycle hooks (`SessionStart`, `Stop`, `PreCompact`) are still
   runtime-specific and not replaced by a CLI-native orchestration wrapper.
2. Subagent audit hook (`SubagentStart`) still depends on runtime event support.
3. Full contract test matrix for all 48 agents and 37 skills in terminal mode.

## How to Enable the Copilot CLI Path

From repository root:

```bash
bash scripts/setup-git-hooks.sh
```

PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-git-hooks.ps1
```

## Validation Checklist

1. Run an empty commit to verify `pre-commit` execution.
2. Push to a protected branch and confirm `pre-push` warning behavior.
3. Commit an asset/data JSON change and verify post-commit asset validation.

## Next Implementation Batches

### Batch C (P1): Agent and Skill Compatibility Matrix

1. Validate each tool declaration against terminal capabilities.
2. Add compatibility notes per agent/skill where behavior diverges.

### Batch D (P1): Documentation Cleanup

1. Remove operational ambiguity around runtime-only hooks.
2. Replace stale references like `CLAUDE.md` in templates.

### Batch E (P2): Observability and CI

1. Add CI jobs for invariant checks currently local-only.
2. Add optional CLI wrapper logging for session-level auditability.
