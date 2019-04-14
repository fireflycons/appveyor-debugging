# placeholder
Task Init {
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

}

Task Default -Depends Init
