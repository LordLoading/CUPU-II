#!/usr/bin/env pwsh
param(
    [string]$AssembleDir = "."
)

$ErrorActionPreference = "Stop"

$OutDir = "out"

if (Test-Path -LiteralPath $OutDir -PathType Container) {
    Remove-Item -LiteralPath $OutDir -Recurse -Force
}

& .\assemble.ps1 $AssembleDir

& .\emu\emulator.exe -bin .\out\out.bin
