# Creating a function since this is called upon often 
function DR-Make-Temp-Folder
{
  param
  {
    $rootFolder = $PSScriptRoot,
    $folderPrefix = 'temp_'
  } # can change the $rootFolder to be a new variable you created in the line right before, to change the path
    # EX: Line A: $newPath = $PSScriptRoot + "\ABC"
    # EX: Line B: $rootFolder = $newPath
  
  $tempFolderName = $folderPrefix + (Get-Date -Format "yyyyMMddHHmmss")
  $testThis = Test-Path -Path ($rootFolder + $tempFolderName)
  
  if (!$testThis)
  {
    New-Item -Path $rootFolder -Name $tempFolderName -ItemType "directory"
    ($rootFolder + $tempFolderName)
    return
  }
  
  else # returns $false if the folder already exists 
  {
    $false
    return
  }
}
