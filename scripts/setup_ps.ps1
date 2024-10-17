. "$PSScriptRoot/util.ps1"

$PSScriptRoot/install_pkg.ps1 oh-my-posh JanDeDobbeleer.OhMyPosh

###

$modules = @("Terminal-Icons", "posh-git")

foreach ($mod in $modules) {
    if (!(Check-Module $mod)) { Install-Module $mod }
}
