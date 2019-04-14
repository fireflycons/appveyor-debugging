Install-Module psake -Scope CurrentUser -Force

Get-ChildItem ENV:

$varsPresent = $true
('NugetApiKey', 'APPVEYOR_SSH_KEY') |
Foreach-Object {
    if (-not (Test-Path -Path "ENV:$($_)"))
    {
        Write-Warning "Variable $_ is missing"
        $varsPresent = $false
    }
}

if (!$varsPresent)
{
    throw "Failed due to missing vars"
}
