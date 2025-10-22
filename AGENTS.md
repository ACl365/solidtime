# AGENTS — Pia Time working rules

- No Jira. Use GitHub Issues and Discussions only. See POLICY_NO_JIRA.md.
- Minimal diffs. Planner features are strictly gated with `planner.enabled`.
- Defaults unchanged when disabled. API shapes and aggregation match upstream when planner is off.
- PR checklist:
  - Include summary, gating notes, release notes, testing matrix (enabled vs disabled)
  - Migrations are additive only unless explicitly noted
  - Run local checks before push: `scripts/local_check.sh` (or `.ps1`)
- Branching:
  - Feature branches: `feat/...`
  - Planner PRs: pr/planner-prX or feat/pia-planner
- Testing:
  - Disabled: `PLANNER_ENABLED=false` (or `PIA_ENABLED=false`)
  - Enabled: `PLANNER_ENABLED=true` (or `PIA_ENABLED=true`)
