param(
    [ValidateSet('gemma','qwen')]
    [string]$Modell = 'gemma',
    [switch]$Summor,
    [switch]$Verifiera
)

$ErrorActionPreference = 'Stop'
$Rot = $PSScriptRoot
$SummFil = Join-Path $Rot 'SHA256SUMS.txt'

$ModellDefinitioner = @{
    gemma = @{ Repo = 'unsloth/gemma-3n-E4B-it-GGUF'; Fil = 'gemma-3n-E4B-it-Q4_K_M.gguf' }
    qwen  = @{ Repo = 'ggml-org/Qwen3-4B-GGUF';       Fil = 'Qwen3-4B-Q4_K_M.gguf' }
}

function Get-FilSha256 {
    param([string]$Sokvag)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $strom = [System.IO.File]::OpenRead($Sokvag)
        try { ($sha.ComputeHash($strom) | ForEach-Object { $_.ToString('x2') }) -join '' }
        finally { $strom.Dispose() }
    } finally { $sha.Dispose() }
}

function Test-Integritet {
    if (-not (Test-Path $SummFil)) {
        Write-Host 'SHA256SUMS.txt saknas. Kor forbered.bat forst.' -ForegroundColor Red
        return $false
    }
    $script:IntegritetOk = $true
    Get-Content $SummFil | ForEach-Object {
        $del = $_ -split '\s+', 2
        if ($del.Count -ne 2) { return }
        $relSokvag = $del[1].Trim()
        $fil = Join-Path $Rot ($relSokvag -replace '/', '\')
        if (-not (Test-Path $fil)) {
            Write-Host "SAKNAS   $relSokvag" -ForegroundColor Red
            $script:IntegritetOk = $false
        } elseif ((Get-FilSha256 $fil) -ne $del[0]) {
            Write-Host "FEL      $relSokvag" -ForegroundColor Red
            $script:IntegritetOk = $false
        } else {
            Write-Host "OK       $relSokvag" -ForegroundColor Green
        }
    }
    return $script:IntegritetOk
}

function New-Summor {
    $rader = Get-ChildItem -Path $Rot -Recurse -File |
        Where-Object { $_.Name -ne 'SHA256SUMS.txt' -and $_.FullName -notmatch '[\\/]\.git([\\/]|$)' } |
        ForEach-Object {
            $rel = ($_.FullName.Substring($Rot.Length).TrimStart('\','/')) -replace '\\', '/'
            '{0}  {1}' -f (Get-FilSha256 $_.FullName), $rel
        }
    Set-Content -Path $SummFil -Value $rader -Encoding ascii
    Write-Host "SHA256SUMS.txt skapad med $(@($rader).Count) filer."
}

function Save-Nedladdning {
    param([string]$Url, [string]$Mal)
    Write-Host "Laddar ner $Url"
    Invoke-WebRequest -Uri $Url -OutFile $Mal -UserAgent 'usb-ai'
}

function Get-UtgivarensModellSha256 {
    param([string]$Repo, [string]$Fil)
    $trad = Invoke-RestMethod -Uri "https://huggingface.co/api/models/$Repo/tree/main" -UserAgent 'usb-ai'
    $post = $trad | Where-Object { $_.path -eq $Fil } | Select-Object -First 1
    if (-not $post) { throw "Hittade inte $Fil hos $Repo." }
    if ($post.lfs) { return $post.lfs.oid }
    return $post.oid
}

function Installera-LlamaCpp {
    $utgivningar = Invoke-RestMethod -Uri 'https://api.github.com/repos/ggml-org/llama.cpp/releases?per_page=30' -UserAgent 'usb-ai'
    foreach ($arkiv in @(
        @{ Monster = '*bin-win-cpu-x64.zip';  Katalog = 'bin\win-x64' },
        @{ Monster = '*bin-win-cpu-arm64.zip'; Katalog = 'bin\win-arm64' }
    )) {
        $tillgang = $null
        foreach ($utgivning in $utgivningar) {
            $tillgang = $utgivning.assets | Where-Object name -like $arkiv.Monster | Select-Object -First 1
            if ($tillgang) { break }
        }
        if (-not $tillgang) { throw "Hittade inte $($arkiv.Monster) bland llama.cpp:s senaste utgivningar." }
        $zip = Join-Path $env:TEMP $tillgang.name
        Save-Nedladdning -Url $tillgang.browser_download_url -Mal $zip
        $malKatalog = Join-Path $Rot $arkiv.Katalog
        if (Test-Path $malKatalog) { Remove-Item $malKatalog -Recurse -Force }
        Expand-Archive -Path $zip -DestinationPath $malKatalog -Force
        Remove-Item $zip -Force
        Write-Host "Installerade $($arkiv.Katalog)"
    }
}

function Test-Sjalvtest {
    $bin = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'bin\win-arm64' } else { 'bin\win-x64' }
    $server = Join-Path $Rot "$bin\llama-server.exe"
    if (-not (Test-Path $server)) { throw "llama-server.exe saknas i $bin." }
    & $server --version | Out-Host
    if ($LASTEXITCODE -ne 0) { throw 'Sjalvtest av llama-server misslyckades.' }
    Write-Host 'Sjalvtest OK.'
}

if ($Verifiera) {
    if (Test-Integritet) { exit 0 } else { exit 1 }
}

if ($Summor) {
    New-Summor
    exit 0
}

Write-Host '== Forberedelse av masterstickan =='

Installera-LlamaCpp

$def = $ModellDefinitioner[$Modell]
$modellKatalog = Join-Path $Rot 'models'
New-Item -ItemType Directory -Force -Path $modellKatalog | Out-Null
$modellFil = Join-Path $modellKatalog $def.Fil
$vantad = Get-UtgivarensModellSha256 -Repo $def.Repo -Fil $def.Fil
if ((Test-Path $modellFil) -and ((Get-FilSha256 $modellFil) -eq $vantad)) {
    Write-Host 'Modellen finns redan och ar verifierad mot utgivarens SHA256.'
} else {
    Save-Nedladdning -Url "https://huggingface.co/$($def.Repo)/resolve/main/$($def.Fil)" -Mal $modellFil
    $faktisk = Get-FilSha256 $modellFil
    if ($vantad -ne $faktisk) {
        Remove-Item $modellFil -Force
        throw "SHA256 stammer inte for modellen. Nedladdningen togs bort."
    }
    Write-Host 'Modellen verifierad mot utgivarens SHA256.'
}

Test-Sjalvtest

New-Summor
Write-Host 'Klart. Spara en kopia av SHA256SUMS.txt utanfor stickan och sla pa skrivskydd.'
