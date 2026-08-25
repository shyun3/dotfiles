#######################################################################
# Utilities

# See https://stackoverflow.com/a/29424207
function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# See https://stackoverflow.com/a/16949127
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

#######################################################################

# See https://powershellmagazine.com/2013/05/13/pstip-detecting-if-the-console-is-in-interactive-mode/
if ([Environment]::GetCommandLineArgs() -like '-noni*')
{
    return
}

if (Check-Command mise)
{
    (&mise activate pwsh) | Out-String | Invoke-Expression
}

if (Check-Command oh-my-posh)
{
    oh-my-posh init pwsh --config ~/.mytheme.omp.json | Invoke-Expression
}

#######################################################################
# Prompt
# See https://docs.microsoft.com/en-us/windows/terminal/tutorials/custom-prompt-setup

function promptFunc
{
    # Make sure Windows Terminal duplicates new tabs/panes in same directory
    # https://docs.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-with-posh-git
    $loc = Get-Location

    $nextPrompt = & $Function:prompt

    $nextPrompt += "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $nextPrompt += "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
    }

    $nextPrompt
}

Set-Alias -Name prompt -Value promptFunc

#####################################################################

# Use menus for tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# winget tab completion
# See https://docs.microsoft.com/en-us/windows/package-manager/winget/tab-completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# uv completion
if (Check-Command uv)
{
    (& uv generate-shell-completion powershell) | Out-String | Invoke-Expression
    (& uvx --generate-shell-completion powershell) | Out-String | Invoke-Expression
}
