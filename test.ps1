Get-ChildItem ENV:

$varsPresent = $true
('SecureVar', 'APPVEYOR_SSH_KEY', 'TEST_VAR') |
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
