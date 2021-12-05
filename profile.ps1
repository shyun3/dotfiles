function prompt
{
    if ($nestedpromptlevel -ge 1) { return '>> ' }

    # `poetry shell` does not change the prompt, so add the virtualenv name
    $venv = $env:VIRTUAL_ENV
    $venvPrompt = $env:POETRY_ACTIVE -eq 1 -and $venv ?
        '(' + (Get-Item $venv).BaseName + ') ' : ''

    $venvPrompt + 'PS ' + $(pwd) + '> '
}
