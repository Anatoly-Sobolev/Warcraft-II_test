param(
    [Parameter(Mandatory = $true)]
    [string]$ExtractedRoot,

    [string]$OutputRoot = "$PSScriptRoot\reference_assets"
)

$ErrorActionPreference = "Stop"

$resolvedExtractedRoot = Resolve-Path -LiteralPath $ExtractedRoot
$resolvedOutputRoot = if (Test-Path -LiteralPath $OutputRoot) {
    Resolve-Path -LiteralPath $OutputRoot
} else {
    New-Item -ItemType Directory -Path $OutputRoot | Out-Null
    Resolve-Path -LiteralPath $OutputRoot
}

$files = @(
    "graphics\ui\human\infopanel.png",
    "graphics\ui\human\buttonpanel.png",
    "graphics\ui\human\menubutton.png",
    "graphics\ui\human\minimap.png",
    "graphics\ui\human\resource.png",
    "graphics\ui\human\statusline.png",
    "graphics\ui\gold,wood,oil,mana.png",
    "graphics\ui\food.png",
    "graphics\ui\score.png",
    "graphics\ui\workers.png",
    "campaigns\human\interface\introscreen1.png"
)

$copied = New-Object System.Collections.Generic.List[string]
$missing = New-Object System.Collections.Generic.List[string]

foreach ($relativePath in $files) {
    $source = Join-Path -Path $resolvedExtractedRoot -ChildPath $relativePath
    $target = Join-Path -Path $resolvedOutputRoot -ChildPath $relativePath

    if (Test-Path -LiteralPath $source) {
        $targetDirectory = Split-Path -Parent $target
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $target -Force
        $copied.Add($relativePath) | Out-Null
    } else {
        $missing.Add($relativePath) | Out-Null
    }
}

$screenshotsDirectory = Join-Path -Path $resolvedOutputRoot -ChildPath "screenshots"
New-Item -ItemType Directory -Path $screenshotsDirectory -Force | Out-Null

$manifestPath = Join-Path -Path $resolvedOutputRoot -ChildPath "MANIFEST.local.txt"
$manifest = @()
$manifest += "Generated: $(Get-Date -Format s)"
$manifest += "ExtractedRoot: $resolvedExtractedRoot"
$manifest += ""
$manifest += "Copied:"
$manifest += ($copied | ForEach-Object { "- $_" })
$manifest += ""
$manifest += "Missing:"
$manifest += ($missing | ForEach-Object { "- $_" })
$manifest += ""
$manifest += "Screenshots directory:"
$manifest += "- screenshots\"
$manifest | Set-Content -LiteralPath $manifestPath -Encoding UTF8

Write-Host "Copied $($copied.Count) files to $resolvedOutputRoot"
if ($missing.Count -gt 0) {
    Write-Host "Missing $($missing.Count) files. See reference_assets\MANIFEST.local.txt"
}
