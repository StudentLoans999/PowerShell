$folderPath = "\\ABC-app01\Public\Data\Files\"
$fileFilter = "*ABC*.csv"
$subfolderToMoveTo = "ABC Good Files"
$$timeDelayHours = 2 # number of hours to check for if file has been there that long 
$timeDelaySpan = new-timespan -hours $timeDelayHours
$filesLookingFor = Get-ChildItem -Path folderPath -Filter fileFilter -File

ForEach ($theFile in $filesLookingFor)
{
  Write-Host $theFile.Name
  $lastModTime = Get-Date($theFile.LastWriteTime)
  
  if (((Get-Date) - $lastModTime) -gt $timeDelaySpan
  {
    Write-Host "Moving..." $theFile.PSPath
    Move-Item $theFile,PSPath -Destination ($folderPath + $subfolderToMoveTo) -Force
  }
}
