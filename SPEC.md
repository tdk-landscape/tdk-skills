# Spec: portable TDK skills

Status: implemented (2026-10-04) · Package: `tdk-landscape/tdk-skills`

## Goal

One maintained copy of each skill, installable into the directories that agent orchestrators already scan, with no Claude-only layout required.

The tier list is a set of agent orchestrators, not TDK users. Most never look at `.claude-plugin`. They look for a folder containing a `SKILL.md`. So `tdk-skills` becomes a portable Agent Skills package, and the Claude plugin becomes an optional extra.

## Source of truth

Skills move to the root of the `tdk-skills` repo. The plugin tree stops being canonical.

```text
skills/
  tdk-doctor/SKILL.md
  tdk-troubleshoot/SKILL.md
  layer-autoresearch/SKILL.md
rules/
  AGENTS.landscape.md
  AGENTS.cli-core.md
AGENTS.md
agent.yaml
install.sh
.claude-plugin/marketplace.json
plugins/tdk-cli/skills -> ../../skills      (symlink)
```

Each `SKILL.md` follows the [Agent Skills spec](https://agentskills.io/specification): YAML frontmatter, then markdown.

- `name`: required. Must match the folder name, lowercase and hyphenated.
- `description`: required. Says what the skill does and when to use it, under 1024 characters. It is the trigger.
- Body under about 500 lines. Long command tables go in `references/`.

```yaml
---
name: tdk-troubleshoot
description: Diagnose a failed tdk up, Docker, or Tilt session. Use when tdk doctor fails, a service will not start, or localhost routing is broken.
license: MIT
compatibility: Requires tdk CLI, Docker, and Tilt on the local machine. Does not deploy.
metadata:
  author: tdk-landscape
  version: "1.0"
---
```

Do not put Claude-only fields in the canonical file. If a tool needs extra frontmatter, generate it at install time.

## What each orchestrator can load

| Tier | Tool | What to ship |
|---|---|---|
| SS | T3 Code | Project `AGENTS.md`, plus `.agents/skills/<name>/SKILL.md` if it follows Codex-style discovery. **Unverified.** Confirm before claiming; do not assume the plugin command works. |
| S | Omnigent | A small `agent.yaml` with `instructions: AGENTS.md`. Not a skill marketplace. |
| S | Paseo | Generic path below until its docs say otherwise. |
| A–E | OpenCode, Codex, Cursor, Conductor-class tools | `SKILL.md` in the path that tool scans. |

Documented discovery paths to support:

| Path | Tools |
|---|---|
| `.agents/skills/<name>/SKILL.md` | Codex, OpenCode |
| `.claude/skills/<name>/SKILL.md` | Claude Code, OpenCode |
| `.opencode/skills/<name>/SKILL.md` | OpenCode |
| `.cursor/skills/<name>/SKILL.md` | Cursor |

Claude plugin install stays as an optional extra, not the primary path.

## Installer

A user should not have to hand-copy folders. Prefer the existing `npx skills` flow if the repo layout matches it. Otherwise ship an `install.sh` that only copies or symlinks.

```bash
npx skills add tdk-landscape/tdk-skills
# or
curl -fsSL https://raw.githubusercontent.com/tdk-landscape/tdk-skills/main/install.sh | sh -s -- --agent opencode
```

Flags: `--agent claude|codex|opencode|cursor|agents`, `--global`, `--project`.

- Default is a project-local symlink into `.agents/skills/`, plus a symlink into the selected agent's directory.
- Never vendor a second copy of the markdown. The only sanctioned copy is the generated mirror in `tdk-cli-core` (see Consumers).
- No `sudo`. If a target is not writable, fail fast and print the manual command.

## Instructions-only tools

Ship a short root `AGENTS.md` for tools that only read instructions, including Omnigent:

```yaml
name: tdk-local
instructions: AGENTS.md
```

`AGENTS.md` must say:

- TDK is local only.
- Run `tdk doctor`, then `tdk up`.
- Do not invent Kubernetes or Compose.
- The three skills are `tdk-doctor`, `tdk-troubleshoot` and `layer-autoresearch`, with a pointer to each.

## README

Replace the Claude-only install block with three lines: install the CLI, install the skills, copy the rules template.

List every tool from the tier list with one of two entries:

- a verified install path, or
- "uses AGENTS.md only, skill auto-load unverified."

Do not claim T3, Paseo, Hermes or Traycer load `SKILL.md` until that is checked. Do not invent commands for tools that were not verified.

## Consumers

`tdk-cli-core` keeps a generated mirror of these skills in `.claude/skills/` and `.agents/skills/` so it builds without a sibling checkout. `scripts/sync-tdk-skills.sh` there reads `skills/` from this repo. Never edit the mirror; change the skill here and re-run the sync (the workflow is dispatch-only, so it is not triggered automatically).

## Acceptance

- A fresh clone has skills only under `skills/`. Each has valid frontmatter and a matching folder name.
- OpenCode and Codex discover `tdk-doctor` from `.agents/skills` without the Claude plugin.
- Claude Code still installs via the marketplace, and that plugin is a symlink back to `skills/`.
- `AGENTS.landscape.md` still tells project repos not to copy the whole catalog.
- README install works for at least Claude, Codex, OpenCode and Cursor, and does not invent commands for the rest.

## Open questions

- Do T3 Code, Paseo, Hermes or Traycer scan any of the paths above? Check each tool's docs before the README says so.
