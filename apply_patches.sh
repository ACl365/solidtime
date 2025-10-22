#!/usr/bin/env bash
set -euo pipefail

# Apply patches in a deterministic order
# Expected files (already prepared):
#  - PR1: 0001-PR1-*.patch
#  - PR2: 0001-PR2-*.patch
#  - PR5: 0001-PR5-*.patch
#  - NOJIRA: 0001-docs-policy-*.patch (No Jira policy)
#  - BRAND: 0001-docs-brand-*.patch (Pia Time rebrand)

if [ ! -d "patches" ]; then
  echo "patches/ folder not found. Copy patches into this repo root under patches/." >&2
  exit 1
fi

echo "Applying PR1 (Schema + Seeds)"
for p in patches/*PR1*.patch; do [ -e "$p" ] && git am "$p"; done

echo "Applying PR2 (Scaffold + materialization)"
for p in patches/*PR2*.patch; do [ -e "$p" ] && git am "$p"; done

echo "Applying PR5 (gating + tests)"
for p in patches/*PR5*.patch; do [ -e "$p" ] && git am "$p"; done

echo "Applying No Jira policy/docs"
for p in patches/*policy*.patch; do [ -e "$p" ] && git am "$p"; done

echo "Applying branding (Pia Time)"
for p in patches/*brand*.patch; do [ -e "$p" ] && git am "$p"; done

echo "All patches applied."