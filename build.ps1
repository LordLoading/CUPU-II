#!/usr/bin/env pwsh
# for transparency, this script is written by ai because i'm a lazy bastard
$ErrorActionPreference = "Stop"

Write-Host "Building assembler (Zig)..." -ForegroundColor Cyan
Push-Location asm
zig build
Pop-Location

Write-Host "Building linker (D)..." -ForegroundColor Cyan
Push-Location lnk
dub build
Pop-Location

Write-Host "Building emulator (Go)..." -ForegroundColor Cyan
Push-Location emu
go build ./
Pop-Location

Write-Host "All builds complete." -ForegroundColor Green
