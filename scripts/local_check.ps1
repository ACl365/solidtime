Param()
$ErrorActionPreference = 'Stop'

if (-not (Test-Path 'composer.json')) {
  Write-Error 'Run from repo root (composer.json not found)'
}

if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
  Write-Error 'Composer not found. Install Composer or run in container.'
}

composer install --no-interaction --prefer-dist

# Run formatting (non-failing), analysis and tests
try { composer fix } catch {}
try { composer analyse } catch {}
composer test
