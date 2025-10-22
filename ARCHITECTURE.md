# Architecture — Pia Time

## Overview
Pia Time is a light fork of Solidtime with an optional Planner layer for Phases/Milestones. When disabled, behavior matches upstream.

## Domain
- Organizations, Projects, Tasks, TimeEntries (upstream)
- Planner (additive): PhaseTemplate, MilestoneTemplate, ProjectPhase, PhaseMilestone, PlannerRule, UserAlias

## Gating model
- `config('planner.enabled')` -> env `PLANNER_ENABLED` (fallback `PIA_ENABLED`)
- When disabled:
  - No planner routes (404)
  - `TimeEntryResource` hides `milestone_id`
  - Aggregation ignores Phase/Milestone grouping
- When enabled:
  - Controllers accept planner-only filters
  - Aggregation supports Phase/Milestone groupings

## Key flows
- Project create -> `PlannerProjectService` materializes phases/milestones (when enabled)
- Time entry create/update -> optional `milestone_id` link (enabled only)
- Reporting -> optional grouping by Milestone/Phase (enabled only)

## Data
- Additive migrations create planner tables; no destructive changes.

## Extension points (future)
- Import (CSV/UI) -> map milestones to projects
- Jobs/Digests -> Slack summary for upcoming/overdue milestones
- Frontend -> planner toggles, start timer from milestones
- Footer -> AGPL source code link to repo
