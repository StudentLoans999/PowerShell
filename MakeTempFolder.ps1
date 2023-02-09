# Creating a function since this is called upon often - this creates a folder named "temp_date"
function DR-Make-Temp-Folder
{
    #$newPath = "C:\new"
    $rootFolder = $PSScriptRoot #$newPath
    $folderPrefix = 'temp_'
    # can change the $rootFolder to be a new variable you created in the line right before, to change the path
    # EX: Line A: $newPath = $PSScriptRoot + "\ABC"
    # EX: Line B: $rootFolder = $newPath
  
  $tempFolderName = $folderPrefix + (Get-Date -Format "yyyyMMddHHmmss")
  $testThis = Test-Path -Path ($rootFolder + $tempFolderName)
  
  # Create the folder
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

# Run the function created above
$theTempPath = $false
while (!$theTempPath)
{
    $theTempPath = DR-Make-Temp-Folder -RootFolder $PSScriptRoot -FolderPrefix 'temp_'
}

# Get info about new folder created
$theTempPath
Write-Host Test-Path -Path $theTempPath
