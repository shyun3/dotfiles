. "{{@@ scripts_dir @@}}/util.ps1"

if (Check-Command oh-my-posh)
{
    oh-my-posh init pwsh --config "{{@@ _dotdrop_dotpath @@}}/mytheme.omp.json" |
        Invoke-Expression
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
