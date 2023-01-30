param
(
  [string] $serverName = "localhost",
  [string] $DBName = "",
  [string] $TBLName = "",
  [string] $PARTName = "",
  [switch] $processFull,
  [switch] $processData,
  [switch] $processCalc
)
# This script is for refreshing a whole SSMS Azure AS database defined by the parameters
# To be used in conjunction with whatever ProcessCube_*.ps1 script is calling this script, since that ProcessCube script will define the parameters for the Cube Refresh

$refreshType = "Automatic"

# Build Password from CubeCreds file for when Authentication is offline
# Extract password from password file - this is the bit that actually goes in the script
$password = Get-Content "\\ABC-server\Public\Creds\CubeCreds.txt" | convertto-securestring
$username = "david_richey@abc.com"
$credentials = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

# Logging to Host window
Write-Host("Load start time {0}" -f (Get-Date -uformat "%H:%M:%S") )
Write-Host("----------------------------------------------------------------")
Write-Host("Server  : {0}" -f $serverName)
Write-Host("Process Type: $refreshType")
Write-Host("Database  : " + $DBName)

If ($TBLName -ne "") { Write-Host("Table  : " + $TBLName) }
If ($PARTName -ne "") { Write-Host("Partition  : " + $PARTName) }
Write-Host("----------------------------------------------------------------")
Write-Host("DB processing started.  Time: {0}" -f (Get-Date -uformat "%H:%M:%S") )

# What type of Cube refresh based on the Switch parameter caught from whatever ProcessCube_*.ps1 script is calling this script
If ($processFull) { $refreshType = "Full" }
Elseif ($processData) { $refreshType = "DataOnly" }
Elseif ($processCalc) { $refreshType = "Calculate" }

If ($PARTName -ne "")
{
  try
  { 
    $result = Invoke-ProcessPartition -Server $serverName -Database $DBName -TableName $TBLName -PartitionName $PARTName `
    -RefreshType $refreshType -Credential $credentials -ErrorAction Stop
  }
  catch { Write-Host("Failed to refresh the Partition: $PARTName") }
}
Elseif ($TBLName -ne "")
{
  try
  { 
    $result = Invoke-ProcessTable -Server $serverName -Database $DBName -TableName $TBLName `
    -RefreshType $refreshType -Credential $credentials -ErrorAction Stop
  }
  catch { Write-Host("Failed to refresh the Table: $TBLName") }
}
Else
{
  try
  { 
    $result = Invoke-ProcessASDatabase -Server $serverName -Database $DBName -RefreshType $refreshType `
    -Credential $credentials -ErrorAction Stop
  }
  catch { Write-Host("Failed to refresh the Database: $DBName") }
}
