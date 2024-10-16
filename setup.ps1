. "$PSScriptRoot/scripts/util.ps1"

function Grab-Module($Name) {
    if (!(Get-Module $Name)) { Install-Module $Name @args }
}

$cmd_packs = @{
    wt = "Microsoft.WindowsTerminal",
    pwsh = "Microsoft.PowerShell",
    oh-my-posh = "JanDeDobbeleer.OhMyPosh"
}

foreach ($cmd in $cmd_packs.Keys) {
    if (!(Check-Command $cmd)) {
        winget install --id $cmd_packs[$cmd] --source winget --exact
    }
}

Grab-Module -Name Terminal-Icons -Repository PSGallery
Grab-Module posh-git -Scope CurrentUser -Force
