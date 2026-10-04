# TDK (local development)

- TDK is local only. It runs a Docker + Tilt inner loop and does not deploy.
- Run `tdk doctor`, then `tdk up`, from the project root.
- Do not invent Kubernetes manifests or Docker Compose files.

## Skills

Each skill is a folder under `skills/` with a `SKILL.md`:

- `skills/tdk-doctor/SKILL.md`: check or repair the environment and project config before `tdk up`.
- `skills/tdk-troubleshoot/SKILL.md`: diagnose a failed `tdk up`, Docker or Tilt session.
- `skills/layer-autoresearch/SKILL.md`: contributor experiment loop for the L1-L4 Docker layers.

If your tool does not load skills automatically, read the relevant `SKILL.md` directly.

Machine-readable index: `llms.txt`. TDK docs index: https://tdk-landscape.github.io/llms.txt
