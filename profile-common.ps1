Import-Module oh-my-posh
Set-PoshPrompt -Theme paradox

Import-Module -Name Terminal-Icons

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# See https://stackoverflow.com/a/16949127
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}
