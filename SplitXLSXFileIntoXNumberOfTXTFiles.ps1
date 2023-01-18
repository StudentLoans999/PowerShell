# This script will make an array of Months and will split an xlsx file that contains 12 sheets (12 months) into 12 separate txt files, each one being only one sheet (a month), and will archive the original
# EX: Make an array (substring will be added to beginning of each filename), scripts looks for a file in the path, and then splits that into X txt files, each one being one sheet

$checkThisFolder = "\\ABC-app01\Public\Data\Files\"
$archiveFolder = "\\ABC-app01\Public\Data\Files\Archive\"
$targetFolder = "\\ABC-app01\Public\Data\Files\SplitIntoX"

$xArray = @('JAN_', 'FEB_', 'MAR_', 'APR_', 'MAY_', 'JUN_', 'JUL_', 'AUG_', 'SEP_', 'OCT_', 'NOV_', 'DEC_') # change this to whatever type of array you want
$fileFilter = '*ABC*.xlsx'
$files = Get-ChildItem -Path $checkThisFolder -Filter fileFilter -File # can use "gci" instead of "Get-ChildItem"

ForEach ($thisFile in $files)
{
  ForEach ($thisX in $xArray)
  {
    $oldName = $thisFile.Name
    Copy-item -Path $thisFile.FullName -Destination "$targetFolder\$thisX$oldName" -Force # Creates a copy of the xlsx file to the path the flattener will look for it
    $flattenedCommand = '& "\\ABC-app01\Public\Apps\Flattener.exe" + $thisX.substring(0,3) + '.abc' #.substring is 0 and 3 because each item in the array is 4 characters
    
    try
    {
      Invoke-Expression $flattenedCommand
      "$targetFolder\$thisX$oldName"
      Remove-item -Path "$targetFolder\$thisX$oldName" -Force
    } # Flattens the copied xlsx file and creates multiple txt files from it, and then removes the copied xlsx file 
    catch { Write-Host "Flattener failed" }
  }
  Move-item -Path thisFile.FullName -Destination $archiveFolder -Folder # archives the original xlsx file
}
