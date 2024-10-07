Import-Module oh-my-posh
Set-PoshPrompt -Theme paradox

Import-Module -Name Terminal-Icons

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$origPrompt = (Get-Command Prompt).ScriptBlock

function prompt
{
    # Make sure Windows Terminal duplicates new tabs/panes in same directory
    # https://docs.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-with-posh-git
    $loc = Get-Location
    $cwdSeq = "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $cwdSeq += "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
    }

    ($origPrompt | Invoke-Expression) + $cwdSeq
}

# See https://stackoverflow.com/a/16949127
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}
