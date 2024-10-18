param ($pkg, $cmd)

. $PSScriptRoot/util.ps1

if (!(Check-Command $cmd)) { winget install --id $pkg --source winget --exact }
