#!/usr/bin/env bash
set -euo pipefail

if [ ! -f composer.json ]; then
  echo "Run from repo root (composer.json not found)" >&2
  exit 1
fi

if ! command -v composer >/dev/null 2>&1; then
  echo "Composer not found. Install Composer or run in container." >&2
  exit 1
fi

composer install --no-interaction --prefer-dist

# Run formatting (non-failing), analysis and tests
composer fix || true
composer analyse || true
composer test
