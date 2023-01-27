$exceptionFileFilter = "*ABC*.csv"

$folderPath = "\\ABC-server\Public\Data\Files\"
$fileFilter = "*.csv"

# Get all filtered files in folder path provided above
$filesLookingFor = (Get-ChildItem -Path $folderPath -Filter $fileFilter) # can also use "gci" instead of "Get-ChildItem"

ForEach ($theFile in $filesLookingFor)
{
  if($theFile.Name -like $exceptionFileFilter)
  {
    Write-Host "Exception file - so will not rename"
    Continue
  }
  
  Else
  {
    Try
    {
      Rename-Item -Path $folderPath$theFile ($theFile.BaseName.insert($theFile.Name.Length-4, "r") + $theFile.Extension) # Length- is one number higher than extension length
      $renamedFile = $theFile
    }
    Catch { Write-Host "This file can't be renamed: $theFile" }
  }
  
  $logFilePath = "\\ABC-server\Public\Data\Files\RenamerWithExceptionLog.txt"
  $logMessage = "The renaming script renamed $renamedFile and was run at"
  $logMessage +" - "+ (Get-Date).ToSTring() >> $logFilePath
}
