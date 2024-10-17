param ($cmd, $pkg)

. $PSScriptRoot/util.ps1

if (!(Check-Command $cmd)) { winget install --id $pkg --source winget --exact }
