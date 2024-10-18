. $PSScriptRoot/util.ps1

& $PSScriptRoot/install_pkg.ps1 JanDeDobbeleer.OhMyPosh oh-my-posh

$modules = @("Terminal-Icons", "posh-git")
foreach ($mod in $modules) {
    if (!(Check-Module $mod)) { Install-Module $mod -Force }
}
