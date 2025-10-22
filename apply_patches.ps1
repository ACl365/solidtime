Param()
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -Path 'patches' -PathType Container)) {
  Write-Error 'patches/ folder not found. Copy patches into this repo root under patches/.'
}

function Apply-PatchesByPattern {
  param([string]$Pattern)
  Get-ChildItem -Path patches -Filter $Pattern -File | ForEach-Object {
    Write-Host "Applying $($_.Name)"
    git am --whitespace=fix --3way $_.FullName
  }
}

Write-Host 'Applying PR1 (Schema + Seeds)'
Apply-PatchesByPattern '*PR1*.patch'

Write-Host 'Applying PR2 (Scaffold + materialization)'
Apply-PatchesByPattern '*PR2*.patch'

Write-Host 'Applying PR5 (gating + tests)'
Apply-PatchesByPattern '*PR5*.patch'

Write-Host 'Applying No Jira policy/docs'
Apply-PatchesByPattern '*policy*.patch'

Write-Host 'Applying branding (Pia Time)'
Apply-PatchesByPattern '*brand*.patch'

Write-Host 'All patches applied.'