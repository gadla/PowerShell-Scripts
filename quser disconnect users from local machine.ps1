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
        Add-Content -Path 'C:\Temp\DiUser.txt' -Value "$((Get-Date).ToString()),$($u.USERNAME),$($u.'IDLE TIME')" -Force
        Logoff $u.ID
    }
}