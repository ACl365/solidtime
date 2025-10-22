# Pia Time — Planner-enabled time tracking for Pia Design

Pia Time is a light fork tailored for a 3‑person interior design studio. It keeps upstream Solidtime defaults, and adds an optional Planner layer to link time to milestones and report by Phase/Milestone — all strictly gated and with minimal diffs.

- No Jira: We track everything with GitHub Issues and Discussions in this repo.
- License: AGPLv3

## Features

- Time tracking with a clean UI
- Projects, tasks, clients, roles/permissions (from upstream)
- Optional Planner layer (when enabled):
  - Start timer from milestones
  - Group reporting by Milestone or Phase (Phase maps to tags)
  - Filters: Milestones‑only, chosen Milestones, Phase prefix/tags

## Planner gating

- Enable: set `PLANNER_ENABLED=true` (falls back to `PIA_ENABLED=true` if not set)
- When `planner.enabled=false`:
  - API/exports/UI behave like upstream Solidtime (no milestone_id in responses; no extra columns)
- Config: `config/planner.php` supports `default_leadtime_days` and `alert_window_days` (env‑overridable)

## Getting started (local)

1) Copy env and install backend deps

```
cp .env.example .env
composer install
php artisan key:generate
```

2) Run migrations and seed (optional for planner demo data)

```
PIA_ENABLED=true PIA_TEMPLATES_AUTO_SEED=true php artisan migrate --seed
```

3) Run tests

```
composer test
```

## Contributing

No Jira: we use GitHub Issues and Discussions as the single source of truth. Document decisions in PRs and in the repository (docs/).

Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) before submitting a Pull Request.

## Security

See [SECURITY.md](./SECURITY.md).

## License

AGPL v3 — see [LICENSE.md](LICENSE.md).
