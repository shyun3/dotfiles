. "$PSScriptRoot/scripts/util.ps1"

$cmd_packs = @{
    wt = "Microsoft.WindowsTerminal";
    "oh-my-posh" = "JanDeDobbeleer.OhMyPosh"
}

foreach ($cmd in $cmd_packs.Keys) {
    if (!(Check-Command $cmd)) {
        winget install --id $cmd_packs[$cmd] --source winget --exact
    }
}

Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module posh-git -Scope CurrentUser -Force
