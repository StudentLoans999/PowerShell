# This script will process the Cube by Table, and when it gets to the TableC table, it will process SOME X of the monthly partitions, based on how many months back you want

# Part 1: Process the tables that don't have partitions

$listOfTables = ("TableA", "TableB") # these tables don't have partitions

# Loop on the non-partitioned tables
ForEach ($thisTable in $listOfTables)
{ 
  & '\\ABC-server\Public\Scripts\RefreshCubePartitions.ps1' -ServerName 'ABC-serverB' `
  -DBName 'ABCDB' `
  -TBLName $thisTable `
  -ProcessFull 
} # the -ServerName and other ones with a - are parameters that are being set here and are being sent to the RefreshCubePartitions.ps1

# Part 2: Process the table that does have partitions: TableC

# Set Variables to begin processing TableC which isn't just one partition like the rest, but holds Monthly partitions in this case, with the name format of yyyyMM
$partitionList = @() # create a list for the partitions
$currentDate = Get-Date  # use this to decicde how many X months back of partitions to process from this current date

# Need this first line to process the current monthly partition
$partitionList += $currentDate.ToString("yyyyMM")
# Each line below represents a monthly partition that will get processed - so just insert X many lines for X number of months back you want to process, and increment the number
# It is currently set to do 2 monthly partitions, the 2 months before the most current partition 
$partitionList += $currentDate.addMonths(-1).ToString("yyyyMM")
$partitionList += $currentDate.addMonths(-2).ToString("yyyyMM")

# ^ This will process 3 months of partitions. Todays date is January 2023, so it will process these partitions: 202301, 202212, and 202211

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
