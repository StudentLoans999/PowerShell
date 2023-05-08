# Rename and move files from whichever child folder it comes from (all inside the same parent folder) based on the Regularity and Country string in its filenname
  # 1. Finds non-default regularity and moves it to the front of the filename 
  # 2. Removes redundant date that was in the filename 
  # 3. Adds child folder name to end of the filename
  # 4. Adds current date timestamp to end of the filename
  # 5. Finds non-default country and moves it to front of the filename
  # 6. Moves all renamed files into a new folder, based on the country name in it's filename

$parentFolder = "\\ABC-server\Public\Data\Other Files\" # where original files are
$fileExtFilter = "*.csv" # type of original files (the filter to select the right files)

$regularity = "Weekly_" # this is a string in the filename that has a non-default regularity filename (default: Daily) Ex: Weekly_ ; Monthly_ ; Yearly_

$fileExt = ".csv" # used to add to the renamed file
$today = Get-Date -Format "yyyy-MM-dd" # used to create a date stamp
$today = "_TS$today" # used to label the CA files so that they are differentiatied from US ## first 3 characters are used in Substring step later

$kindOfFile1 = "RedXYZ" # what the raw Red file started as
$kindOfFile1Renamed = "Red" # used to label the Red file
$kindOfFile2 = "YellowXYZ" # what the raw Yellow file started as
$kindOfFile2Renamed = "Yellow" # used to label the Yellow file

$kindOfFileA = "SquareXYZ" # what the raw Square file started as
$kindOfFileARenamed = "Square" # used to label the Square file
$kindOfFileB = "CircleXYZ" # what the raw Circle file started as
$kindOfFileBRenamed = "Circle" # used to label the Circle file

$nonUSCountryName = "ABC CA" # string to look for, for non-defualt country filename
$importUSPath = "\\ABC-server\Public\Data\US Renamed\" # where default renamed file gets moved to
$importnonUSPath = "\\ABC-server\Public\Data\Not US Renamed\" # where non-default country renamed file gets moved to

# Get all filtered files in the folder and renames each file
$filesLookingFor = (Get-ChildItem -Path $parentFolder -Filter $fileExtFilter)

  foreach ($theFile in $filesLookingFor) # loops through all files found in the folder
  {
    $newFileName = $theFile.Name
    
    # Renames kindOfFile1/kindOfFile2 kindOfFileA/kindOfFileB (if one exists) in the filename
    $newFileName = $theFile -Replace "$kindOfFile1", "$kindOfFile1Renamed"
    $newFileName = $theFile -Replace "$kindOfFile2", "$kindOfFile2Renamed"
    $newFileName = $theFile -Replace "$kindOfFileA", "$kindOfFileARenamed"
    $newFileName = $theFile -Replace "$kindOfFileB", "$kindOfFileBRenamed"
    
    Write-Host "Renamed kindOfFile1/kindOfFile2 kindOfFileA/kindOfFileB if exists`n" -ForegrounfColor Green
    Write-Host $newFileName
    
    # Removes redundant date in filename (if one exists) (only applies on daily files) ## can be changed to look for and replace any other redundant string in the filename 
    $newFileName = $newFileName -Replace "(_\d{1,2}-\d{1,2}-\d{4})\1","`${1}" # date format: mm-dd-yyyy ## adds this date format to the end of the filename
    $newFileName = $newFileName -Replace "(_\d{4}-\d{1,2}-\d{1,2})\1","`${1}" # date format: yyyy-mm-dd ## adds this date format to the end of the filename
     
    Write-Host "Removed redundant date `n" -ForegrounfColor Red
    Write-Host $newFileName
    
    # Renames Weekly filename to have Weekly_ at the start of it (if one exists) (only applies on weekly files) ## can be changed to look for and replace any other redundant string in the filename
    if ($newFileName -match "[-0-9]{8,10}_[-0-9]{8,10}") # if there are two date intervals
    {
      $newFileName = $newFileName -Replace "$newFileName", "$weekly$newFileName" #
      $newFileName = $newFileName -Replace "_[-0-9]{10,12}(_[-0-9]{10,12})","`${1}" # find two dates next to each other and replace with the second date only

      Write-Host "Renamed Weekly filename to have Weekly_ at the start of it `n" -ForegrounfColor Red
      Write-Host $newFileName
    }
    
    # Adds the current date timestamp to the end of the filename (if doesn't exist already)
    if ($newFileName -notmatch ($today.Substring(0,3))) # if doesn't already have _TS in the filename
    {
      $newFileName = $newFileName -Replace "$fileExt", "xyz$today$fileExt" # the "xyz" is just to show you can add characters too 
      Write-Host "Added timestamp`n" -ForegrounfColor Magenta
      Write-Host $newFileName
    }
    
    # Saves the changes of the New filename to the original file
    Write-Host "Trying to rename $theFile to $newFileName"
    Rename-Item -Path $theFile.FullName -NewName $newFileName -Force
    
    $originalDirectory = $theFile.Directory # filepath of the original file
    $renamedFilePath = "$originalDirectory\$newFileName" # updated filepath of the renamed file
    
    # Moves files to respective Renamed folder, depending on if it is US or a different country, or Daily or Weekly
    if ($newFileName.Contains($nonUSCountryName)) { Move-Item $renamedFilePath -Destination ($importnonUSPath) -Force }
    else { Move-Item $renamedFilePath -Destination ($importUSPath) -Force }
  }
