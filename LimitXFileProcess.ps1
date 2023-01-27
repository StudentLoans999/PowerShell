# This script limits how many times a process (X) gets run. In this case it is moving files (so only 5 files get moved at once)
$checkThisFolder = "\\ABC-server\Public\Data\Files\Done"
$fileFilter = "*ABC*.xlsx"
$targetFolder = "\\ABC-server\Public\Data\Files\"
$numberToLimit = 5
$thisFileNumber = 1

Get-ChildItem - Path $checkThisFolder -Filter $fileFilter | Foreach-Object
{
  if ($thisFileNumber -le $numberToLimit) # loops $numberToLimit of times
  {
    Move-item -Path $_.FullName -Destination $targetFolder # here you can do whatever process you want limited
    $thisFileNumber++
  }
}
