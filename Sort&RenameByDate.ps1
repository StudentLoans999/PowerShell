# Sorts files found in folder by modified date, descending, and then renames each file with a number starting with 1 and also adds a _ at the front of the filename 

$folderPath = "\\ABC-server\Public\Data\Unsorted Files\"
$fileFilter = "*.txt"

# Get all filtered files in folder path provided above
$filesLookingFor = (Get-ChildItem -Path $folderPath -Filter $fileFilter) | Sort-Object lastwritetime # sorts files found in folder by modified date, descending

$ie = 1

ForEach ($theFile in $filesLookingFor)
{
  Try # Renames files with previous number + 1
  {
    $newName = ($ie.ToString("0000")+"_"+$theFile.Name) # uses .ToString("0000") since 0001 evnentually goes to 0010 for the second digit which is right, but not converting it would be 1 going to 10 with could be a problem with software automation
    Write-Host "Renaming to: $newName "
    Rename-Item -Path $folderPath$theFile $newName
    $ie += 1
  }
  Catch
  {
    Write-Host "This file can't be renamed: $theFile\nException:$_"
  {
}
