# PR5 groundwork: planner gating + tests

Labels: feature, gated, planner, minimal-diff
Status: Draft
Base: main (adjust if repo uses `develop`)
Head: pr/planner-pr5

## Summary
This PR adds planner gating across controllers, resources, and aggregation services, plus unit tests validating behavior in both modes. When `planner.enabled=false`, Solidtime behavior remains unchanged (API shapes, aggregations, exports). When enabled, planner-specific filters and groupings are applied.

## Scope
- Controllers: apply planner-only filters only when planner is enabled. Controllers ignore milestone/phase filters when disabled.
- API Resources: `TimeEntryResource` hides `milestone_id` when planner is disabled.
- Aggregation: services ignore Phase/Milestone grouping when planner is disabled; with planner enabled, Phase/Milestone grouping is available.
- Unit tests: added to cover enabled vs disabled paths.

## Gating
- Feature flag: `planner.enabled` (falls back to `PIA_ENABLED`).
- Config: `config/planner.php` includes `default_leadtime_days=42` and `alert_window_days=10` (overridable via `.env`).
- Defaults: When disabled, no UI/API shape changes and Solidtime remains unchanged.

## Test Matrix
- Disabled mode (`PLANNER_ENABLED=false` or `PIA_ENABLED=false`):
  - Controllers ignore planner-only filters (`milestones_only`, `phase_prefix`, `milestone_ids`).
  - Resources: `milestone_id` omitted from payloads.
  - Aggregations: no Phase/Milestone grouping; shapes identical to baseline Solidtime.
- Enabled mode (`PLANNER_ENABLED=true` or `PIA_ENABLED=true`):
  - Controllers: planner filters applied.
  - Aggregations: support Phase/Milestone grouping.
  - Ensure no changes outside planner-specific flows.

## Verification Steps
1) Install deps and configure env
```
cp .env.example .env
composer install
php artisan key:generate
```
2) Run migrations and seed (optional for fuller data)
```
PIA_ENABLED=true PIA_TEMPLATES_AUTO_SEED=true php artisan migrate --seed
```
3) Disabled mode checks
```
export PLANNER_ENABLED=false # or PIA_ENABLED=false
composer test
```
- Confirm resources omit `milestone_id` and aggregations do not include Phase/Milestone grouping.

4) Enabled mode checks
```
export PLANNER_ENABLED=true # or PIA_ENABLED=true
composer test
```
- Confirm controllers accept planner-only filters and aggregation exposes Phase/Milestone groupings.

## Release Notes
- Added planner gating for milestone/phase filters and groupings; no destructive changes.
- Backward compatible when disabled.

## Migration Note
- No destructive schema changes. Migrations from PR1 create planner tables; this PR does not alter schema.

## Related / Follow-ups
- PR1: "Planner Schema + Seeds (gated)"
- PR2: "Planner UI + API scaffold + materialization (gated)"
- PR3 (follow-up): Import backend + `ImportPlanner.vue`
- PR4 (follow-up): Jobs + Slack digest
- PR5 (follow-up): Frontend toggles + start-timer from milestones
- PR6 (follow-up): AGPL footer "Source code" link to running version
