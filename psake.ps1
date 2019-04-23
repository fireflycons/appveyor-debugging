Properties {

    try
    {
        $script:IsWindows = (-not (Get-Variable -Name IsWindows -ErrorAction Ignore)) -or $IsWindows
        $script:IsLinux = (Get-Variable -Name IsLinux -ErrorAction Ignore) -and $IsLinux
        $script:IsMacOS = (Get-Variable -Name IsMacOS -ErrorAction Ignore) -and $IsMacOS
        $script:IsCoreCLR = $PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core'
    }
    catch { }

    $TestsPath = Join-Path $PSScriptRoot tests
    $Timestamp = Get-date -uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = Join-Path $PSScriptRoot "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'
}

Task Test {
    Write-Host $lines
    Write-Host "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $pesterParameters = @{
        Path         = $TestsPath
        PassThru     = $true
        OutputFormat = "NUnitXml"
        OutputFile   = $TestFile
    }

    if (-Not $IsWindows) { $pesterParameters["ExcludeTag"] = "WindowsOnly" }
    $TestResults = Invoke-Pester @pesterParameters

    Write-Host "$TestFile exists? $(Test-Path -Path $TestFile)"

    If ($env:APPVEYOR_JOB_ID)
    {
        $uploadUrl = "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"

        Write-Host "Uploading $TestFile to $uploadUrl"

        $bytes = (New-Object System.Net.WebClient).UploadFile($uploadUrl, $TestFile )

        Write-Host (New-Object System.Text.ASCIIEncoding).GetString($bytes)
    }

    Remove-Item $TestFile -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }

    Write-Host "`n"
}

Task Default -Depends Test

