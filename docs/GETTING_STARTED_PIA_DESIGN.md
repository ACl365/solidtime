# Getting Started — Pia Design

1) Install
- Copy env: `cp .env.example .env`
- Install: `composer install`
- Key: `php artisan key:generate`

2) Demo data (optional)
- `PIA_ENABLED=true PIA_TEMPLATES_AUTO_SEED=true php artisan migrate --seed`

3) Planner modes
- Disabled (default): no milestones/phase fields in API/UI
- Enabled: set `PLANNER_ENABLED=true` (or `PIA_ENABLED=true`)

4) Local checks before pushing
- macOS/Linux: `bash scripts/local_check.sh`
- Windows: `./scripts/local_check.ps1`

5) Useful links
- POLICY_NO_JIRA.md
- ARCHITECTURE.md
- AGENTS.md
