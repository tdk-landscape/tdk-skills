# tdk-skills

Portable [Agent Skills](https://agentskills.io/specification) for the TDK CLI. One copy of each skill under `skills/`; the installer symlinks it into the directories your tool scans.

```bash
curl -fsSL https://tdk-landscape.github.io/install.sh | sh                                              # 1. CLI
npx skills add tdk-landscape/tdk-skills                                                                 # 2. skills
curl -fsSL https://raw.githubusercontent.com/tdk-landscape/tdk-skills/main/install.sh | sh -s -- --agent codex   # 2 (alt)
cp rules/AGENTS.landscape.md ./AGENTS.md                                                                # 3. rules template
```

`install.sh` flags: `--agent claude|codex|opencode|cursor|agents`, `--global`, `--project` (default). It always links into `.agents/skills/` and also into the selected agent's directory. `--global` links into the user-level directories (`~/.agents/skills`, `~/.claude/skills`, `~/.cursor/skills`, `~/.config/opencode/skills`). Symlinks point at an absolute path: your checkout, or a clone cached in `~/.local/share/tdk-skills` when run via `curl`; if that moves, re-run the installer. It only symlinks; it never copies the markdown and never uses `sudo`.

## Skills

| Skill | Use |
|---|---|
| `tdk-doctor` | Check or repair the environment and project config before `tdk up`. |
| `tdk-troubleshoot` | Diagnose a failed `tdk up`, Docker or Tilt session. |
| `layer-autoresearch` | Contributor experiment loop for the L1-L4 Docker layers. |

## Tools

| Tool | Status |
|---|---|
| Claude Code | Documented path `.claude/skills/<name>/SKILL.md`: `install.sh --agent claude`. Optional plugin: `/plugin marketplace add tdk-landscape/tdk-skills`, then `/plugin install tdk-cli@tdk-skills`. |
| Codex | Documented path `.agents/skills/<name>/SKILL.md`: `install.sh --agent codex`. |
| OpenCode | Documented paths `.agents/skills`, `.claude/skills`, `.opencode/skills`: `install.sh --agent opencode`. |
| Cursor | Documented path `.cursor/skills/<name>/SKILL.md`: `install.sh --agent cursor`. |
| Omnigent | Uses `AGENTS.md` only (see `agent.yaml`); skill auto-load unverified. |
| T3 Code | Uses `AGENTS.md` only; skill auto-load unverified. |
| Paseo | Uses `AGENTS.md` only; skill auto-load unverified. |
| Hermes | Uses `AGENTS.md` only; skill auto-load unverified. |
| Traycer | Uses `AGENTS.md` only; skill auto-load unverified. |
| Conductor-class tools | Uses `AGENTS.md` only; skill auto-load unverified. |

`npx skills add tdk-landscape/tdk-skills` was run against a fresh project (2026-10-04): it found all three skills and installed them into `.agents/skills/`, which it treats as the shared path for Codex, OpenCode and Cursor, and linked them into `.claude/skills/` for Claude Code. `install.sh --agent opencode` was also run and produced working symlinks.

The per-tool paths above otherwise come from each tool's documented discovery behaviour and have not been re-tested end to end. `rules/AGENTS.landscape.md` tells project repos not to copy the whole catalog.

## Repository guidance

- [`rules/AGENTS.landscape.md`](rules/AGENTS.landscape.md) is a short baseline for TDK project, example and starter repositories.
- [`rules/AGENTS.cli-core.md`](rules/AGENTS.cli-core.md) applies only to contributors working in `tdk-cli-core`.

Copy the applicable template into a repository as its root `AGENTS.md`, then add only rules specific to that repository. Generated directories may keep their own generated `AGENTS.md` fences.

## Updating skills

Edit `skills/` only; the plugin and `.agents/skills/` are symlinks. Review a skill here first. Product-specific command behavior should be checked against [`tdk-cli-core`](https://github.com/tdk-landscape/tdk-cli-core) before publishing. Keep any mirror in the CLI repository synchronized from this source instead of editing two independent copies.

## For agents and LLMs

- [`llms.txt`](llms.txt) indexes every skill and rules template with raw URLs.
- [`AGENTS.md`](AGENTS.md) is the short instruction file for tools that don't load skills.
- The TDK site publishes its own index at <https://tdk-landscape.github.io/tdk-website/llms.txt> and a guide at <https://tdk-landscape.github.io/tdk-website/docs/agents/>.

See [SPEC.md](SPEC.md) for the design.

## License

MIT; see [`LICENSE`](LICENSE).
