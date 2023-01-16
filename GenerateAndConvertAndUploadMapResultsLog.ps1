param([string]$folderPath = "\\ABC-app01\Public\Data\Results\")

## This file is found here: \\ABC-app01\Public\PowerShell
## If this script will be run by automation (Windows Scheduler, etc.), add the -NonInteractive Switch to it to prevent the Excel task that runs from hanging 

# Temporary Logging
# Start-Transcript -Path \\ABC-app01\Public\Logs\LogOfMapResultsLog.txt -Append

# If the folder file path is not created through the Parameter in Line 1, enter the File Path here, by replacing $folderPath
$inputFolderName = $folderPath

# Generate the .txt file in \\ABC-app01\Public\Data\Results\ which will be called MapResults*.txt by running this: CreateMapResultsTXT.bat 
& \\ABC-app01\Public\Batch\CreateMapResultsTXT.bat

if (!$inputFolderName)
{
  Write-Host -ForegroundColor Red "Variable is null. Pelase update script or use the -FolderPath Switch. Example DoSomething.ps1 - FolderPath 'C:\Folder\Path\Here'"
  Write-Host ("Variable is null. Pelase update script or use the -FolderPath Switch.")
  Exit
}

[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
  $interopAssembly = [Reflection.Assembly]::LoadWithPartialname("Microsoft.Office.Interop.Excel")
  
# Get all *.txt in foldr provided above
$allWbks = @((Get-ChildItem -Path $inputFolderName -Filter "*.txt"))

# Can't find the text files in the given folder?
if (!$allWbks)
{
  Write-EventLog -EventId "5001" -LogName "Application" -Message "Can't find text files in given folder. Check Path/Source." -Source "Application"
  Write-Host -ForegroundColor Red "Can't find any text files in given folder. 'r'n Check $folderPath for files."
  Exit
}

# Run this section right before opening the Excel file (it is setting up a process later on in the script that prevents the new Excel task from hanging)
$excelBefore = Get-Process EXCEL -IncludeUserName | select name, starttime, UserName, Id | Sort-Object -Property starttime
$excelBefore
Write-Output "'n All Excel Tasks currently running"

## Opening/Save As section
# Create the new Excel app
$excel = new-object Microsoft.Office.Interop.Excel.ApplicationClass
#$excel.Visible = "true"
Get-date

# Run this section right after opening the Excel file
Write-Output "'n The Excel Task just created in this script (will be blank if none)"
$excelNew = Get-Process EXCEL -IncludeUserName | Where-Object { $_.UserName -eq "ABC\david_richey" } | select name, starttime, UserName, Id | Sort-Object -Property starttime | Select-Object -Last 1
$excelNew

Write-Host -ForegroundColor Yellow "'n'n The Excel Task just created along with the rest of the Excel tasks (that were running before this script)"
$excelBefore = Get-Process EXCEL -IncludeUserName | select name, starttime, UserName, Id | Sort-Object -Property starttime
$excelBefore

Try
{
  $xlFixedFormat = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbook
  
  $allWbks | %
  { # loop on found workbooks:
    $file = $_.FullName
    "File: " + $file
    
    # Remove "\\ABC-app01\Public\Data\Results\" from the .txt file; it is implicit:
    $originalText = Get-Content -Path $file
    $newText = $originalText -replace '\\\\ABC-app01\\Public\\Data\\Results\\',''
    # Write-Host $newText
    $newText | Set-Content -Path $file

    # Build file name for new Excel file
