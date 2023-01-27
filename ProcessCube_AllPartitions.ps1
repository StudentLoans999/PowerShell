$listOfTables = ("TableA", "TableB", "TableC")

# Loop on Tables A and B (which don't have Partitions)
ForEach ($thisTable in $listOfTables)
{ 
  & '\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1' -ServerName 'ABC-serverB' `
  -DBName 'ABCDB' `
  -TBLName $thisTable `
  -ProcessFull 
} # the -ServerName and other ones with a - are parameters that are being set here and are being sent to the RefreshCubePartitions.ps1

# Set Variables to begin processing TableC which isn't just one partition like the rest, but holds Monthly partitions in this case
$currentDate = Get-Date # to know when/which is the most recent monthly partition that needs to be processed

$partitionList = @()
