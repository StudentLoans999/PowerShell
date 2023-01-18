# This script limits how many times a process (X) gets run. In this case it is moving files (so only 5 files get moved at once)
$checkThisFolder = "\\ABC-app01\Public\Data\Files\Done"
$fileFilter = "*ABC*.xlsx"
$targetFolder = "\\ABC-app01\Public\Data\Files\"
$numberToLimit = 5
$thisFileNumber = 1

Get-ChildItem - Path $checkThisFolder -Filter $fileFilter | Foreach-Object
{
  if ($thisFileNumber -le $numberToLimit)
  {
    Move-item -Path $_.FullName -Destination $targetFolder # here you can do whatever process you want limited
    $thisFileNumber++
  }
}
