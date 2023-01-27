param([string]$folderPath = "\\ABC-server\Public\Data\Results\")

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

## Opening/Save As section ##

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
    $newText = $originalText -replace '\\\\ABC-server\\Public\\Data\\Results\\',''
    # Write-Host $newText
    $newText | Set-Content -Path $file

    # Build file name for new Excel file:
    $path = ($file).substring(0, ($file).lastindexOf(".")) # remove original extension
    $path += ".xlsx" # add new extension
    
    $book = $excel.Workbooks.Open($file)
    "open $file"
    
    Write-Host $book.Name -BackgroundColor Red
    
    $theWorksheet = $book.ActiveSheet
    "worksheet set"
    
    # Insert blank row for header
    $shiftDownCommand = -4121 # code Excel uses
    
    $topRow = $theWorksheet.cells.item(1,1).entireRow
    $active = $topRow.activate()
    $active = $topRow.insert.($shiftDownCommand)
    # add header text:
    $theWorksheet.cells.item(1,1) = "File Name:"
    $theWorksheet.cells.item(1,2) = "Processed:"
    $theWorksheet.cells.item(1,3) = "Results"
    # add warning:
    $newTopRow = $theWorksheet.cells.item(1,1).entireRow
    $active = $topRow.activate()
    $active = $topRow.insert.($shiftDownCommand)
    # add header text:
    $theWorksheet.cells.item(1,1) = "Updated:" + (Get-Date)
    $theWorksheet.cells.item(1,2) = "Warning:"
    $theWorksheet.cells.item(1,3) = "Leaving this file open in Teams will keep it from being updated."
    
    "Format"
    # 'm/d/yyyy h:mm AM/PM'
    $theWorksheet.columns.item(2).NumberFormat = 'm/d/yyyy h:mm AM/PM'
    
    "Autofit"
    $theWorksheet.UsedRange.EntireColumn.AutoFit() | Out-Null
    # this doesn't seem to be honored in Teams, but Excel sees it
   
    $book.saveas($path, $xlFixedFormat)
    
    $book.close()
    Start-Sleep -s 5
    
    # Run this section right after closing the Excel file
    Write-Output "'n Killed the Excel Task that was created in this script"
    $excelKill = $excelNew | Stop-Process
    $excelKill
    Start-Sleep -s 5
    
    # Delete the processed .txt file
    Remove-Item $file
    
    Write-Host "$file was processed into $path and deleted"
  } # end of loop on found workbooks
  
  $excel.Quit()
  Start-Sleep -s 5
  
  $excel = $null
  
  Clear-Variable allWbks
  
  # Run this section right after closing the Excel file ; It is repeated here to make sure it gets closed
  Write-Output "'n Killed the Excel Task that was created in this script"
  $excelKill = $excelNew | Stop-Process
  $excelKill
  
  Start-Sleep -s 5
} # end of Try

Catch
{
  Write-Host -EventId "5001" '
    -LogName "Application" '
    -Message "There was a problem in the Opening/Refreshing/Closing Section of the script." '
    -Source "Application"
  Get-date
  
  # Clean things up after failure:
  $book.Close($false) # close workbook without saving changed (hence "($false)")
  
  Start-Sleep -s 5
  $excel.Quit()
  Start-Sleep -s 5
  
  $excel = $null
  
  Clear-Variable allWbks
  
  # Run this section right after closing the Excel file ; It is repeated here to make sure it gets closed
  Write-Output "'n Killed the Excel Task that was created in this script"
  $excelKill = $excelNew | Stop-Process
  $excelKill
  
  Start-Sleep -s 5
} # end of Catch

Write-Host "Finished Processsing aka Converting text to xlsx"
# Import Module
Import-Module SharePointPnPPowerShellOnline

## Create Secure Stored Cred Password File
#read-host -assecurestring | convertfrom-securestring | out-file "\\ABC-app01\Public\Creds\DavidRicheyUser.txt"
# Compile Creds for Authentication below
$password = get-content "\\ABC-server\Public\Creds\DavidRicheyUser.txt" | convertto-securestring
$creds = new-object -typename System.Management.Automation.PSCredential -argumentlist "David.Richey@ABC.com",$password

# Variables/Pathing - Trailing slashed (/,\) Utilized later in the script
$sharepointURL = "https://ABC.sharepoint.com/sites/ABCData/"
$localPath = "\\ABC-app01\Public\Data\Results\"
$teamsFolderPath = "Shared Documents/Gemeral/ABC Logs"

# Connect to Sharepoint
Connect-PnPOnline $sharepointURL -Credentials $creds -Verbose

If (Test-Path ($localPath + "MapResultsLog.xlsx")) 
{ 
  Write-Host "Old file found; removing"
  Remove-Item -Path ($localPath + "MapResultsLog.xlsx")
}

# Foreach Item Upload
$LHD = (Get-ChildItem -Path $localPath -Filter "*.xlsx")
$uploadError = $null

Foreach ($item in $LHD) # looping in order to make sure fodler stays clean
{
  Rename-Item -Path $item.FullName -NewName "MapResultsLog.xlsx"
  
  $theFile = ($localPath + "MapResultsLog.xlsx")
  
  Try { Add-PnPFile -Folder $teamsFolderPath -Path $theFile -ErrorVariable uploadError }
  Catch
  {
    "Error occurred in $theFile Upload; the log is probably open in Teams"
    Write-Host $uploadError
  }
  
  # clean up after success
  if (!$uploadError)
  {
    Remove-Item -Path $theFile
    # if the file is still in the folder, we will know that the upload failed; the likely cause is that someone has the previous log open in Teams
  }
} # end of foreach

# (Clean up and) Back out of Sharepoint
Disconnect-PnPOnline
