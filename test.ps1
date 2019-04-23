$modules = Get-Module -ListAvailable

('pester', 'psake') |
Where-Object {
    $m = $_
    -not ($modules | Where-Object { $_.Name -ieq $m } )
} |
Foreach-Object {
    Install-Module $_ -Scope CurrentUser -Force
}

Import-Module pester,psake

Invoke-psake -buildFile .\psake.ps1

exit ( [int]( -not $psake.build_success ) )