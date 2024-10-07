Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function prompt
{
    # `poetry shell` does not change the prompt, so add the virtualenv name
    $venvPrompt = $env:POETRY_ACTIVE -eq 1 -and $env:VIRTUAL_ENV ?
        '(' + (Get-Item $env:VIRTUAL_ENV).BaseName + ') ' : ''

    $defaultPrompt = 'PS ' +
        $($executionContext.SessionState.Path.CurrentLocation) +
        "$('>' * ($nestedPromptLevel + 1)) "

    $venvPrompt + $defaultPrompt
}

# See https://stackoverflow.com/a/16949127
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}
