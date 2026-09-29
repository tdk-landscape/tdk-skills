# TDK Skills

Shared agent skills and repository guidance for projects in the [TDK Landscape organization](https://github.com/tdk-landscape).

This repository is the source of truth for reusable CLI skills and baseline repository rules. Keep project-specific instructions in each project's `AGENTS.md`; do not copy this entire skill catalog into every repository.

## Install the Claude plugin

```text
/plugin marketplace add tdk-landscape/tdk-skills
/plugin install tdk-cli@tdk-skills
```

The plugin currently includes:

- `tdk-troubleshoot`: diagnose TDK, Docker and Tilt problems using verified guidance.

Claude Code discovers skills in the plugin automatically. For other agents, copy or adapt the relevant files under `skills/` and use the appropriate local skill directory.

Codex discovers the same skills through `.agents/skills/`. Those entries are symlinks into the plugin's `plugins/tdk-cli/skills/` source, so each skill has one maintained copy.

## Repository guidance

- [`rules/AGENTS.landscape.md`](rules/AGENTS.landscape.md) is a short baseline for TDK project, example and starter repositories.
- [`rules/AGENTS.cli-core.md`](rules/AGENTS.cli-core.md) applies only to contributors working in `tdk-cli-core`.

Copy the applicable template into a repository as its root `AGENTS.md`, then add only rules specific to that repository. Generated directories may keep their own generated `AGENTS.md` fences.

## Updating skills

Edit and review a skill here first. Product-specific command behavior should be checked against [`tdk-cli-core`](https://github.com/tdk-landscape/tdk-cli-core) before publishing. Keep any mirror in the CLI repository synchronized from this source instead of editing two independent copies.

## License

The skills and rules in this repository are available under the MIT License; see [`LICENSE`](LICENSE).
