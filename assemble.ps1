#!/usr/bin/env pwsh
# for transparency, this script is written by ai because i'm a lazy bastard
$ErrorActionPreference = "Stop"

$Assembler = "asm/zig-out/bin/assembler.exe"
$Linker = "lnk/linker.exe"

if (-not (Test-Path $Assembler -PathType Leaf)) {
    Write-Host "Error: assembler not found at $Assembler" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $Linker -PathType Leaf)) {
    Write-Host "Error: linker not found at $Linker" -ForegroundColor Red
    exit 1
}

function Assemble-File {
    param(
        [string]$AsmFile,
        [string]$OutFile
    )
    $outDir = Split-Path -Parent $OutFile
    if (-not (Test-Path $outDir)) {
        New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }
    Write-Host "Assembling: $AsmFile -> $OutFile"
    & $Assembler $AsmFile $OutFile
}

function Link-Files {
    param(
        [string]$ODir,
        [string]$BinOut = "out.bin"
    )
    if (-not (Test-Path $ODir -PathType Container)) {
        Write-Host "Warning: object directory '$ODir' does not exist, skipping link." -ForegroundColor Yellow
        return
    }
    Write-Host "Linking: $ODir -> $BinOut"
    & $Linker $ODir $BinOut
}

$pwdPath = (Get-Location).Path

function Get-AsmFiles {
    param([string]$Root = ".")
    Get-ChildItem -LiteralPath $Root -Recurse -Filter *.asm -File | ForEach-Object {
        $rel = $_.FullName.Substring($pwdPath.Length + 1)
        if ($rel -notmatch '^\.git\\' -and $rel -notmatch '\\\.git\\' -and 
            $rel -notmatch '\\zig-out\\' -and $rel -notmatch '\\\.zig-cache\\') {
            $_
        }
    }
}

$oOutputDir = ""

if ($args.Count -eq 0) {
    $oOutputDir = "out"
    foreach ($asmFile in (Get-AsmFiles)) {
        $rel = $asmFile.FullName.Substring($pwdPath.Length + 1)
        $outFile = Join-Path $oOutputDir ($rel -replace '\.asm$', '.o')
        Assemble-File -AsmFile $asmFile.FullName -OutFile $outFile
    }
} elseif ($args.Count -eq 1) {
    $input = $args[0]
    if (Test-Path $input -PathType Leaf) {
        $oOutputDir = "out"
        $name = [System.IO.Path]::GetFileNameWithoutExtension($input)
        $outFile = Join-Path $oOutputDir "$name.o"
        Assemble-File -AsmFile $input -OutFile $outFile
    } elseif (Test-Path $input -PathType Container) {
        $oOutputDir = "out"
        $resolvedInput = Resolve-Path $input
        $inputPath = $resolvedInput.Path
        $asmFiles = Get-ChildItem -LiteralPath $inputPath -Recurse -Filter *.asm -File
        foreach ($asmFile in $asmFiles) {
            $rel = $asmFile.FullName.Substring($inputPath.Length + 1)
            $outFile = Join-Path $oOutputDir ($rel -replace '\.asm$', '.o')
            Assemble-File -AsmFile $asmFile.FullName -OutFile $outFile
        }
    } else {
        Write-Host "Error: input path '$input' does not exist" -ForegroundColor Red
        exit 1
    }
} elseif ($args.Count -eq 2) {
    $input = $args[0]
    $output = $args[1]
    if (Test-Path $input -PathType Leaf) {
        $oOutputDir = Split-Path -Parent $output
        if (-not $oOutputDir) { $oOutputDir = "." }
        Assemble-File -AsmFile $input -OutFile $output
    } elseif (Test-Path $input -PathType Container) {
        $oOutputDir = $output
        $resolvedInput = Resolve-Path $input
        $inputPath = $resolvedInput.Path
        $asmFiles = Get-ChildItem -LiteralPath $inputPath -Recurse -Filter *.asm -File
        foreach ($asmFile in $asmFiles) {
            $rel = $asmFile.FullName.Substring($inputPath.Length + 1)
            $outFile = Join-Path $oOutputDir ($rel -replace '\.asm$', '.o')
            Assemble-File -AsmFile $asmFile.FullName -OutFile $outFile
        }
    } else {
        Write-Host "Error: input path '$input' does not exist" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [input_path] [output_path]" -ForegroundColor Red
    Write-Host "  No args   : assemble all .asm files recursively, output to out/"
    Write-Host "  1 arg     : input file -> out/<name>.o, or input dir -> out/ (recursive)"
    Write-Host "  2 args    : input file -> output file, or input dir -> output dir (recursive)"
    exit 1
}

$binOut = Join-Path $oOutputDir "out.bin"
Link-Files -ODir $oOutputDir -BinOut $binOut

Write-Host "Done."
