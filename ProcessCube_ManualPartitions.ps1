# This script will process the Cube by whatever monthly partitions you input

$partitionList = ('201712', '201711', '201710') # input the partitions you want to process

# Loop on the list of partitions and refresh each
ForEach ($thisPartition in $partitionList)
{
  # Now we add the PARTName parameter
  $refreshCommand =
  (
    '& "\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1" ' +
    '-ServerName 'ABC-serverB' -DBName ABCDB ' +
    '-TBLName TableC -PARTName ' +
    $thisPartition +
    ' -ProcessFull'
  )
  
  Invoke-Expression $refreshCommand
}
