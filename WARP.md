# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project summary
- Laravel 12 backend (API + Inertia) with Vue 3/TypeScript frontend under resources/js
- Optional Planner layer (Phases/Milestones) gated by config('planner.enabled') → env PLANNER_ENABLED (falls back to PIA_ENABLED)
- Additional TS packages: resources/js/packages/ui (component library) and resources/js/packages/api (OpenAPI Zod client)

Core commands
Backend (PHP)
- Install deps
```bash path=null start=null
composer install
```
- App key and migrations (planner demo data optional)
```bash path=null start=null
php artisan key:generate
PIA_ENABLED=true PIA_TEMPLATES_AUTO_SEED=true php artisan migrate --seed
```
- Serve (plain PHP dev server)
```bash path=null start=null
php artisan serve
```
- Tests
```bash path=null start=null
composer test                # run phpunit via artisan
composer ptest               # run tests in parallel
composer test:coverage       # terminal coverage
composer coverage-report     # HTML coverage to ./coverage
```
- Run a single PHP test
```bash path=null start=null
php artisan test --filter NameOfTestOrMethod
# or
vendor/bin/phpunit --filter NameOfTestOrMethod
```
- Static analysis and formatting
```bash path=null start=null
composer analyse   # phpstan (Larastan)
composer fix       # Laravel Pint
```
- Generate TS models from PHP (when needed)
```bash path=null start=null
composer generate-typescript
```

Frontend (Vite + Vue 3 + TS)
- App-level (resources/js)
```bash path=null start=null
npm run dev                 # Vite dev server
npm run build               # build assets
npm run type-check          # vue-tsc
npm run lint                # eslint
npm run lint:fix            # eslint --fix
npm run format              # prettier write
npm run format:check        # prettier check
```
- E2E tests (Playwright)
```bash path=null start=null
npm run test:e2e
# Single test or grep
npx playwright test tests/example.spec.ts
npx playwright test -g "test name"
```
- Generate OpenAPI Zod client (requires API docs running at /docs/api.json)
```bash path=null start=null
npm run zod:generate
```

Combined local checks
- macOS/Linux: scripts/local_check.sh
- Windows: scripts/local_check.ps1
```bash path=null start=null
# macOS/Linux
bash scripts/local_check.sh
```
```pwsh path=null start=null
# Windows
./scripts/local_check.ps1
```

Optional: Docker (local stack)
- Starts Laravel app (php artisan serve in-container) + Postgres, with Traefik labels for host routing
```bash path=null start=null
docker compose up -d pgsql laravel.test
```

High-level architecture
- Routing
  - API: routes/api.php under prefix /api/v1 with auth:api + verified; public subset under /api/v1/public
  - Web (Inertia): routes/web.php, gated planner pages only when config('planner.enabled') is true
- Controllers/Requests/Resources
  - app/Http/Controllers/Api/V1/* implement REST endpoints; validation in app/Http/Requests/V1/*
  - API responses shaped via app/Http/Resources/* (collections/resources); pagination wrapper PaginatedResourceCollection
- Domain models (app/Models)
  - Core: Organization, Project, Task, Tag, Member, ProjectMember, TimeEntry, Client, Report, User
  - Planner (additive, gated in API/UI): PhaseTemplate, MilestoneTemplate, ProjectPhase, PhaseMilestone, PlannerRule, UserAlias
- Services (app/Service)
  - Application logic: TimeEntryService/Filter/Aggregation, ReportService/Export, Invitation/Organization/Member services, PlannerProjectService/PlannerTemplateService
- Jobs/Events/Listeners
  - Background recalculations (e.g., RecalculateSpentTimeForProject), audit and housekeeping
- Auth and tokens
  - Jetstream/Fortify for web auth; Passport for API tokens (ApiTokenController + resources)
- Frontend
  - Inertia pages in resources/js/Pages; shared components in resources/js/Components
  - TS path alias @/* → resources/js/* (see tsconfig.json)
  - UI library in resources/js/packages/ui (built via Vite; peer-deps Vue/Tailwind/etc.)
  - API client in resources/js/packages/api (generated with openapi-zod-client)

Planner gating (Pia Design layer)
- Toggle: config/planner.php → 'enabled' = env('PLANNER_ENABLED', env('PIA_ENABLED', false))
- When disabled
  - Planner routes are not registered; API and UI behave like upstream Solidtime
  - Responses omit planner-only fields (e.g., milestone_id in TimeEntryResource)
  - Aggregations ignore Phase/Milestone grouping
- When enabled
  - Controllers accept planner filters; reporting can group by Phase/Milestone
  - Project creation can materialize phases/milestones via PlannerProjectService
- Related env/config
  - PIA_ENABLED, PLANNER_ENABLED
  - PIA_TEMPLATES_AUTO_SEED (seed default phase/milestone templates)
  - PLANNER_DEFAULT_LEADTIME_DAYS, PLANNER_ALERT_WINDOW_DAYS

Agent rules (from AGENTS.md)
- No Jira: use GitHub Issues and Discussions in this repo
- Keep diffs minimal; all Planner behavior must be behind planner.enabled
- PRs: include summary, gating notes, release notes, testing matrix (planner on/off); migrations additive by default
- Before pushing, run scripts/local_check.sh (or .ps1)
- Branch names: feat/...; planner-focused PRs may use pr/planner-* or feat/pia-planner
- Test both modes explicitly: PLANNER_ENABLED=false and PLANNER_ENABLED=true

Notes and tips specific to this codebase
- API docs are generated via dedoc/scramble; when the app is running locally, /docs/api.json powers npm run zod:generate
- phpunit.xml sets DB_CONNECTION=pgsql_test; docker-compose includes a pgsql_test service to support this
- TypeScript ambient types live in resources/js/types; ensure vue-tsc sees them (configured in root tsconfig.json)
