Install-Module psake -Scope CurrentUser -Force

Invoke-psake -buildFile .\psake.ps1

exit ( [int]( -not $psake.build_success ) )