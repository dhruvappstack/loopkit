<#
.SYNOPSIS
  LoopKit installer for Windows PowerShell (mirrors install.sh).
.EXAMPLE
  ./install.ps1 -Target C:\code\myproject -Agent claude
#>
[CmdletBinding()]
param(
  [string]$Target = ".",
  [ValidateSet("claude","copilot","cursor","generic","all","none")][string]$Agent = "all",
  [switch]$Upgrade,
  [switch]$Force
)
$ErrorActionPreference = "Stop"
$Version = "0.1.0"
$Src = Join-Path $PSScriptRoot "templates"
if (-not (Test-Path $Target)) { throw "Target directory not found: $Target" }
$Target = (Resolve-Path $Target).Path
$created = 0; $updated = 0; $skipped = 0

function Test-Managed([string]$rel) { $rel -eq ".loop/LOOP.md" -or $rel -like ".loop/playbooks/*" }

function Copy-LoopFile([string]$src, [string]$dst, [string]$rel) {
  New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
  if (Test-Path $dst) {
    if ($Force -or ($Upgrade -and (Test-Managed $rel))) {
      if ((Get-FileHash $src).Hash -eq (Get-FileHash $dst).Hash) { $script:skipped++ }
      else { Copy-Item $src $dst -Force; Write-Host "  updated  $rel"; $script:updated++ }
    } else { Write-Host "  skip     $rel (exists)"; $script:skipped++ }
  } else { Copy-Item $src $dst; Write-Host "  created  $rel"; $script:created++ }
}

function Add-Snippet([string]$snip, [string]$dst, [string]$rel) {
  New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
  $block = Get-Content $snip -Raw
  if (-not (Test-Path $dst)) { Copy-Item $snip $dst; Write-Host "  created  $rel"; $script:created++; return }
  $text = Get-Content $dst -Raw
  if ($text -match "<!-- loopkit:start -->") {
    if ($Force -or $Upgrade) {
      $clean = [regex]::Replace($text, "(?s)<!-- loopkit:start -->.*?<!-- loopkit:end -->\r?\n?", "")
      Set-Content $dst ($clean.TrimEnd() + "`n`n" + $block) -NoNewline
      Write-Host "  updated  $rel (LoopKit block)"; $script:updated++
    } else { Write-Host "  skip     $rel (LoopKit block present)"; $script:skipped++ }
  } else { Add-Content $dst ("`n" + $block); Write-Host "  appended $rel"; $script:updated++ }
}

function Install-Tree([string]$base, [string]$prefix) {
  Get-ChildItem $base -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
    $rel = ($_.FullName.Substring($base.Length + 1) -replace "\\", "/")
    if ($prefix) { $rel = "$prefix/$rel" }
    if ($rel.EndsWith(".snippet")) {
      $out = $rel.Substring(0, $rel.Length - 8)
      Add-Snippet $_.FullName (Join-Path $Target $out) $out
    } else { Copy-LoopFile $_.FullName (Join-Path $Target $rel) $rel }
  }
}

Write-Host "Installing LoopKit $Version into $Target"
Write-Host "Spine (.loop/):"
Install-Tree (Join-Path $Src ".loop") ".loop"
Set-Content (Join-Path $Target ".loop/.loopkit-version") $Version

$adapters = switch ($Agent) {
  "all" { @("claude-code","copilot","cursor","generic") }
  "claude" { @("claude-code") }
  "none" { @() }
  default { @($Agent) }
}
foreach ($a in $adapters) { Write-Host "Adapter ($a):"; Install-Tree (Join-Path $Src "adapters/$a") "" }
Write-Host "`nDone: $created created, $updated updated, $skipped unchanged/skipped."
