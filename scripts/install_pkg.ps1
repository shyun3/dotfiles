param ($cmd, $pkg)

. "$PSScriptRoot/scripts/util.ps1"

if (!(Check-Command $cmd)) {
    winget install --id $cmd_packs[$cmd] --source winget --exact
}
