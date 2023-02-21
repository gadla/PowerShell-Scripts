<#
    .SYNOPSIS
     This script will disconnect users from the local machine.
    
    .DESCRIPTION
        This script will disconnect users from the local machine.
        The script will log the disconnection activiey to a log file.
        The file will be in the format of comma seperated value (csv).
        The file will contain the following columns:
            1. Date
            2. User Name
            3. Idle Time
        
        Pre-requisites:
            1. The script should be run as an administrator.
            2. The log file should be in a path that exists.

    .PARAMETER LogFile
        Mandatory parameter
        The log file path.
        The file will be in the format of comma seperated value (csv).
    
    .EXAMPLE
        .\quser disconnect users from local machine.ps1 -LogFile 'C:\Log\Qlog.csv'
        

#>
[CmdletBinding()]
param (
    [string]
    [parameter(Mandatory = $true)]
    [ValidateScript({
        if( -Not ($_.Substring(0,$_.LastIndexOf('\')) | Test-Path) ){
            throw "The Path of $($_.Substring(0,$_.LastIndexOf('\'))) does not exist "
        }
        return $true
    })]
    $LogFile
)
$User = (((quser) -replace '^>' ,'') -replace '\s{2,}',',').Trim() | ForEach-Object {
    if ($_.split(',').count -eq 5) { 
        Write-Output ($_ -replace '(^[^,]+)', '$1,')
    }
    else
    {
        Write-Output $_
    }
} | ConvertFrom-Csv

foreach($u in $User)
{
    if ($u.state -eq 'disc')
    {
        Add-Content -Path $LogFile -Value "$((Get-Date).ToString()),$($u.USERNAME),$($u.'IDLE TIME')" -Force
        Logoff $u.ID
    }
}