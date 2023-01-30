# This script will process the Cube by Table, and when it gets to the TableC table, it will process ALL the monthly partitions

$listOfTables = ("TableA", "TableB", "TableC") # TableC has monthly partitions

# Part 1: Process the tables that don't have partitions
# Loop on Tables A and B (which don't have Partitions)
ForEach ($thisTable in $listOfTables)
{ 
  & '\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1' -ServerName 'ABC-serverB' `
  -DBName 'ABCDB' `
  -TBLName $thisTable `
  -ProcessFull 
} # the -ServerName and other ones with a - are parameters that are being set here and are being sent to the RefreshCubePartitions.ps1

# Part 2: Process the table that does have partitions
# Set Variables to begin processing TableC which isn't just one (zero) partition like the rest, but holds Monthly partitions in this case, with the name format of yyyyMM
$currentDate = Get-Date # to know when/which is the most recent monthly partition that needs to be processed

# Start with the oldest partitions
$partitionList = @() # create a list for the partitions
$startDate = Get-Date -Date "2016-01-01" # this is the oldest partition to process
$monthsOffset = 0 # will increment until current month is reached
$continueAddingDates = $True

# Loop (backwards) from the current date of the numbered partitions until "startDate" is reached
while ($continueAddingDates)
{
  # Add the next partition to the list
  $partitionList += $currentDate.addMonths($monthsOffset).ToString("yyyyMM")
  
  # Check if reached the last needed partition
  If (($currentDate.addMonths($monthsOffset).ToString("yyyyMM")) -eq ($startDate.ToString("yyyyMM")) )
  {
    # Just added the most recent partition with date to the list, so time to stop
    $continueAddingDates = $False
  }
  
  # Haven't reached the end (of the partitions to process), so increment and go again
  $monthsOffset --
}

# Loop on the list of partitions and refresh each
ForEach ($thisPartition in $partitionList)
{
  # Now we add the PARTName parameter
  & '\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1' -ServerName 'ABC-serverB' `
  -DBName 'ABCDB' `
  -TBLName 'TableC' `
  -PARTName $thisPartition `
  -ProcessFull
}

# Do a -ProcessCalc on the TableC table (this is a huge table and doing this kind of Process saves time)
& '\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1' -ServerName 'ABC-serverB' `
  -DBName 'ABCDB' `
  -TBLName 'TableC' `
  -ProcessCalc
