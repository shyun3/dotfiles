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

function Check-Module($module)
{
    return [bool](Get-Module -ListAvailable -Name $module)
}
