$folderPath = ""
$fileFilter = "*.txt"

# Get all filtered files in folder path provided above
$filesLookingFor = (Get-ChildItem -Path $folderPath -Filter $fileFilter) | Sort-Object lastwritetime # sorts files found in folder by modified date, descending

$ie = 1

ForEach ($theFile in $filesLookingFor)
{
  Try
  {
    $newName = ($ie.ToString("0000")+"_"+$theFile.Name)
    Write-Host "Renaming to: $newName "
    Rename-Item -Path $folderPath$theFile $newName
    $ie += 1
  }
  Catch
  {
    Write-Host "This file can't be renamed: $theFile\nException:$_"
  {
}
