## Why This Exists

This repository is based on Donchitos' original project:
https://github.com/Donchitos/Claude-Code-Game-Studios#

This fork is maintained for personal use with Copilot CLI.

The goal of this repository is to store AI instructions and workflows for agentic game development while keeping a structured multi-agent studio setup.

---

## Table of Contents

- [What's Included](#whats-included)
- [Studio Hierarchy](#studio-hierarchy)
- [Slash Commands](#slash-commands)
- [Getting Started](#getting-started)
- [Upgrading](#upgrading)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Design Philosophy](#design-philosophy)
- [Customization](#customization)
- [Platform Support](#platform-support)

---

## What's Included

| Category      | Count | Description                                                                                               |
| ------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| **Agents**    | 48    | Specialized subagents across design, programming, art, audio, narrative, QA, and production               |
| **Skills**    | 37    | Slash commands for common workflows (`/start`, `/sprint-plan`, `/code-review`, `/brainstorm`, etc.)       |
| **Hooks**     | 8     | Automated validation on commits, pushes, asset changes, session lifecycle, agent audit, and gap detection |
| **Rules**     | 11    | Path-scoped coding standards enforced when editing gameplay, engine, AI, UI, network code, and more       |
| **Templates** | 29    | Document templates for GDDs, ADRs, sprint plans, economy models, faction design, and more                 |

## Studio Hierarchy

Agents are organized into three tiers, matching how real studios operate:

```
Tier 1 - Directors (Opus)
  creative-director    technical-director    producer

Tier 2 - Department Leads (Sonnet)
  game-designer        lead-programmer       art-director
  audio-director       narrative-director    qa-lead
  release-manager      localization-lead

Tier 3 - Specialists (Sonnet/Haiku)
  gameplay-programmer  engine-programmer     ai-programmer
  network-programmer   tools-programmer      ui-programmer
  systems-designer     level-designer        economy-designer
  technical-artist     sound-designer        writer
  world-builder        ux-designer           prototyper
  performance-analyst  devops-engineer       analytics-engineer
  security-engineer    qa-tester             accessibility-specialist
  live-ops-designer    community-manager
```

### Engine Specialists

The template includes agent sets for all three major engines. Use the set that matches your project:

| Engine              | Lead Agent          | Sub-Specialists                                 |
| ------------------- | ------------------- | ----------------------------------------------- |
| **Godot 4**         | `godot-specialist`  | GDScript, Shaders, GDExtension                  |
| **Unity**           | `unity-specialist`  | DOTS/ECS, Shaders/VFX, Addressables, UI Toolkit |
| **Unreal Engine 5** | `unreal-specialist` | GAS, Blueprints, Replication, UMG/CommonUI      |

## Slash Commands

Type `/` in Copilot Code to access all 37 skills:

**Reviews & Analysis**
`/design-review` `/code-review` `/balance-check` `/asset-audit` `/scope-check` `/perf-profile` `/tech-debt`

**Production**
`/sprint-plan` `/milestone-review` `/estimate` `/retrospective` `/bug-report`

**Project Management**
`/start` `/project-stage-detect` `/reverse-document` `/gate-check` `/map-systems` `/design-system`

**Release**
`/release-checklist` `/launch-checklist` `/changelog` `/patch-notes` `/hotfix`

**Creative**
`/brainstorm` `/playtest-report` `/prototype` `/onboard` `/localize`

**Team Orchestration** (coordinate multiple agents on a single feature)
`/team-combat` `/team-narrative` `/team-ui` `/team-release` `/team-polish` `/team-audio` `/team-level`

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- Agentic CLI
- Git Bash (recommended on Windows)
- **Recommended**: [jq](https://jqlang.github.io/jq/) (for hook validation) and Python 3 (for JSON validation)

All hooks fail gracefully if optional tools are missing - nothing breaks, you just lose validation.

For Copilot CLI in terminal, install git hooks locally to enforce commit/push checks:

```bash
bash scripts/setup-git-hooks.sh
```

On PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-git-hooks.ps1
```

### Setup

1. **Clone or use as template**:

   ```bash
   git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
   cd my-game
   ```

2. **Open Copilot** and start a session:

   ```bash
   copilot
   ```

3. **Run `/start`** - the system asks where you are (no idea, vague concept,
   clear design, existing work) and guides you to the right workflow. No assumptions.

   Or jump directly to a specific skill if you already know what you need:
   - `/brainstorm` - explore game ideas from scratch
   - `/setup-engine godot 4.6` - configure your engine if you already know
   - `/project-stage-detect` - analyze an existing project

## Upgrading

Already using an older version of this template? See [UPGRADING.md](UPGRADING.md)
for step-by-step migration instructions, a breakdown of what changed between
versions, and which files are safe to overwrite vs. which need a manual merge.

## Project Structure

```
AGENTS.md                           # Master configuration
.agents/
  settings.json                     # Legacy runtime hooks/permissions (Claude-compatible)
  agents/                           # 48 agent definitions (markdown + YAML frontmatter)
  skills/                           # 37 slash commands (subdirectory per skill)
  hooks/                            # 8 hook scripts (bash, cross-platform)
  rules/                            # 11 path-scoped coding standards
  docs/
    quick-start.md                  # Detailed usage guide
    agent-roster.md                 # Full agent table with domains
    agent-coordination-map.md       # Delegation and escalation paths
    setup-requirements.md           # Prerequisites and platform notes
    templates/                      # 28 document templates
src/                                # Game source code
assets/                             # Art, audio, VFX, shaders, data files
design/                             # GDDs, narrative docs, level designs
docs/                               # Technical documentation and ADRs
tests/                              # Test suites
tools/                              # Build and pipeline tools
prototypes/                         # Throwaway prototypes (isolated from src/)
production/                         # Sprint plans, milestones, release tracking
```

## How It Works

### Agent Coordination

Agents follow a structured delegation model:

1. **Vertical delegation** - directors delegate to leads, leads delegate to specialists
2. **Horizontal consultation** - same-tier agents can consult each other but cannot make binding cross-domain decisions
3. **Conflict resolution** - disagreements escalate up to the shared parent (`creative-director` for design, `technical-director` for technical)
4. **Change propagation** - cross-department changes are coordinated by `producer`
5. **Domain boundaries** - agents do not modify files outside their domain without explicit delegation

### Collaborative, Not Autonomous

This is **not** an auto-pilot system. Every agent follows a strict collaboration protocol:

1. **Ask** - agents ask questions before proposing solutions
2. **Present options** - agents show 2-4 options with pros/cons
3. **You decide** - the user always makes the call
4. **Draft** - agents show work before finalizing
5. **Approve** - nothing gets written without your sign-off

You stay in control. The agents provide structure and expertise, not autonomy.

### Automated Safety

Safety is provided in two layers:

1. **Git hooks (Copilot CLI path)** installed via `scripts/setup-git-hooks.*`
2. **Runtime hooks in `.agents/settings.json`** for Claude-compatible runtimes

Git hooks installed for Copilot CLI:

| Hook          | Trigger      | What It Does                                                                |
| ------------- | ------------ | --------------------------------------------------------------------------- |
| `pre-commit`  | `git commit` | Runs `validate-commit.sh` (design/doc checks, JSON validity, code warnings) |
| `pre-push`    | `git push`   | Runs `validate-push.sh` (protected branch warnings)                         |
| `post-commit` | Commit done  | Runs `validate-assets.sh` in advisory mode                                  |

Runtime hooks defined in `.agents/settings.json`:

| Hook                 | Trigger                  | What It Does                                                                                    |
| -------------------- | ------------------------ | ----------------------------------------------------------------------------------------------- |
| `validate-commit.sh` | `git commit`             | Checks for hardcoded values, TODO format, JSON validity, design doc sections                    |
| `validate-push.sh`   | `git push`               | Warns on pushes to protected branches                                                           |
| `validate-assets.sh` | File writes in `assets/` | Validates naming conventions and JSON structure                                                 |
| `session-start.sh`   | Session open             | Loads sprint context and recent git activity                                                    |
| `detect-gaps.sh`     | Session open             | Detects fresh projects (suggests `/start`) and missing documentation when code/prototypes exist |
| `pre-compact.sh`     | Context compression      | Preserves session progress notes                                                                |
| `session-stop.sh`    | Session close            | Logs accomplishments                                                                            |
| `log-agent.sh`       | Agent spawned            | Audit trail of all subagent invocations                                                         |

`settings.json` permission rules apply only in runtimes that implement that schema. In Copilot CLI terminal mode, rely on git hooks plus repository policy/CI for enforcement.

### Path-Scoped Rules

Coding standards are automatically enforced based on file location:

| Path                | Enforces                                                    |
| ------------------- | ----------------------------------------------------------- |
| `src/gameplay/**`   | Data-driven values, delta time usage, no UI references      |
| `src/core/**`       | Zero allocations in hot paths, thread safety, API stability |
| `src/ai/**`         | Performance budgets, debuggability, data-driven parameters  |
| `src/networking/**` | Server-authoritative, versioned messages, security          |
| `src/ui/**`         | No game state ownership, localization-ready, accessibility  |
| `design/gdd/**`     | Required 8 sections, formula format, edge cases             |
| `tests/**`          | Test naming, coverage requirements, fixture patterns        |
| `prototypes/**`     | Relaxed standards, README required, hypothesis documented   |

## Design Philosophy

This template is grounded in professional game development practices:

- **MDA Framework** - Mechanics, Dynamics, Aesthetics analysis for game design
- **Self-Determination Theory** - Autonomy, Competence, Relatedness for player motivation
- **Flow State Design** - Challenge-skill balance for player engagement
- **Bartle Player Types** - Audience targeting and validation
- **Verification-Driven Development** - Tests first, then implementation

## Customization

This is a **template**, not a locked framework. Everything is meant to be customized:

- **Add/remove agents** - delete agent files you do not need, add new ones for your domains
- **Edit agent prompts** - tune agent behavior, add project-specific knowledge
- **Modify skills** - adjust workflows to match your team's process
- **Add rules** - create new path-scoped rules for your project's directory structure
- **Tune hooks** - adjust validation strictness, add new checks
- **Pick your engine** - use the Godot, Unity, or Unreal agent set (or none)
