param(
    [string]$ExtractedRoot = "external\wargus_extracted",
    [string]$ReferenceRoot = "$PSScriptRoot\reference_assets",
    [string]$BoardsRoot = "$PSScriptRoot\generated_boards"
)

$ErrorActionPreference = "Stop"

$resolvedExtractedRoot = Resolve-Path -LiteralPath $ExtractedRoot
New-Item -ItemType Directory -Path $ReferenceRoot -Force | Out-Null
New-Item -ItemType Directory -Path $BoardsRoot -Force | Out-Null

$assetRoot = Join-Path -Path $ReferenceRoot -ChildPath "extracted"
New-Item -ItemType Directory -Path $assetRoot -Force | Out-Null

$pngFiles = Get-ChildItem -Recurse -File -LiteralPath $resolvedExtractedRoot |
    Where-Object { $_.Extension -ieq ".png" } |
    Sort-Object FullName

function Get-RelativePath {
    param(
        [string]$BasePath,
        [string]$FullPath
    )

    $base = [System.IO.Path]::GetFullPath($BasePath)
    if (-not $base.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
        $base = $base + [System.IO.Path]::DirectorySeparatorChar
    }

    $baseUri = New-Object System.Uri($base)
    $fullUri = New-Object System.Uri([System.IO.Path]::GetFullPath($FullPath))
    $relativeUri = $baseUri.MakeRelativeUri($fullUri)
    return [System.Uri]::UnescapeDataString($relativeUri.ToString()) -replace "/", "\"
}

foreach ($file in $pngFiles) {
    $relativePath = Get-RelativePath -BasePath $resolvedExtractedRoot -FullPath $file.FullName
    $targetPath = Join-Path -Path $assetRoot -ChildPath $relativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $targetPath) -Force | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $targetPath -Force
}

function Convert-ToMarkdownPath {
    param([string]$Path)

    return ($Path -replace "\\", "/")
}

function New-Board {
    param(
        [string]$Title,
        [string]$OutputFile,
        [object[]]$Files
    )

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# $Title") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("Generated from: ``$resolvedExtractedRoot``") | Out-Null
    $lines.Add("") | Out-Null
    $lines.Add("PNG count: $($Files.Count)") | Out-Null
    $lines.Add("") | Out-Null

    $currentGroup = ""
    foreach ($file in $Files) {
        $relativePath = Get-RelativePath -BasePath $resolvedExtractedRoot -FullPath $file.FullName
        $group = ($relativePath -split "[\\/]")[0]
        if ($group -ne $currentGroup) {
            $currentGroup = $group
            $lines.Add("## $currentGroup") | Out-Null
            $lines.Add("") | Out-Null
        }

        $copiedRelative = Join-Path -Path "..\reference_assets\extracted" -ChildPath $relativePath
        $markdownPath = Convert-ToMarkdownPath $copiedRelative
        $lines.Add("### $relativePath") | Out-Null
        $lines.Add("") | Out-Null
        $lines.Add("![${relativePath}](<$markdownPath>)") | Out-Null
        $lines.Add("") | Out-Null
    }

    $outputPath = Join-Path -Path $BoardsRoot -ChildPath $OutputFile
    $lines | Set-Content -LiteralPath $outputPath -Encoding UTF8
}

$uiFiles = $pngFiles | Where-Object { $_.FullName -match "\\graphics\\ui\\" }
$campaignFiles = $pngFiles | Where-Object { $_.FullName -match "\\campaigns\\" }
$animationFiles = $pngFiles | Where-Object {
    $_.FullName -match "\\graphics\\(human|orc|neutral)\\units\\" -or
    $_.FullName -match "\\graphics\\(human|orc|neutral)\\buildings\\" -or
    $_.FullName -match "\\graphics\\missiles\\"
}
$worldFiles = $pngFiles | Where-Object {
    $_.FullName -match "\\graphics\\" -and $_.FullName -notmatch "\\graphics\\ui\\"
}

New-Board -Title "UI Asset Board" -OutputFile "ui_board.md" -Files $uiFiles
New-Board -Title "Campaign And Briefing Board" -OutputFile "campaign_board.md" -Files $campaignFiles
New-Board -Title "Animation Spritesheets Board" -OutputFile "animation_spritesheets_board.md" -Files $animationFiles
New-Board -Title "World Graphics Board" -OutputFile "world_graphics_board.md" -Files $worldFiles
New-Board -Title "Full PNG Catalog" -OutputFile "full_png_catalog.md" -Files $pngFiles

$summary = @(
    "# Generated Boards",
    "",
    "Generated from: ``$resolvedExtractedRoot``",
    "",
    "| Board | PNG count |",
    "| --- | --- |",
    "| [ui_board.md](ui_board.md) | $($uiFiles.Count) |",
    "| [campaign_board.md](campaign_board.md) | $($campaignFiles.Count) |",
    "| [animation_spritesheets_board.md](animation_spritesheets_board.md) | $($animationFiles.Count) |",
    "| [world_graphics_board.md](world_graphics_board.md) | $($worldFiles.Count) |",
    "| [full_png_catalog.md](full_png_catalog.md) | $($pngFiles.Count) |",
    "",
    "All copied images are under `../reference_assets/extracted/` and are ignored by Git."
)
$summary | Set-Content -LiteralPath (Join-Path -Path $BoardsRoot -ChildPath "README.md") -Encoding UTF8

Write-Host "Copied $($pngFiles.Count) PNG files to $assetRoot"
Write-Host "Generated boards in $BoardsRoot"
