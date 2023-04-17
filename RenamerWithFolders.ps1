# Rename and move files from whichever child folder it comes from (all inside the same parent folder) based on the Regularity and Country string in its filenname
  # 1. Finds non-default regularity and moves it to the front of the filename 
  # 2. Removes redundant date that was in the filename 
  # 3. Adds child folder name to end of the filename
  # 4. Adds current date timestamp to end of the filename
  # 5. Finds non-default country and moves it to front of the filename
  # 6. Moves all renamed files into a new folder, based on the country name in it's filename

$parentFolder = "\\ABC-server\Public\Data\Raw Files\" # where original files are
$fileExt = "*.csv" # type of original files

$regularity = "Weekly_" # this is a string in the filename that has a non-default regularity filename (default: Daily) Ex: Weekly_ ; Monthly_ ; Yearly_
$today = Get-Date -Format "yyyy-MM-dd"

$abcCountry = "ABC CA_" # this is a string in the filename that has a non-default country filename (default: US) Ex: ABC CA_ ; ABC CN_ ; ABC UK_

$nonUSCountryName = "ABC CA" # string to look for, for non-defualt country filename
$importUSPath = "\\ABC-server\Public\Data\US Renamed\" # where default renamed file gets moved to
$importnonUSPath = "\\ABC-server\Public\Data\Not US Renamed\" # where non-default country renamed file gets moved to

# Get all filtered files in each folder and renames each file
$filesLookingFor = (Get-ChildItem -Path $parentFolder -Filter $fileExt -Recurse) # -Recurse allows it to seach into all the child folders

  foreach ($theFile in $filesLookingFor) # loops through all files found in the child folders
  {
    # Moves regularity: "Weekly_" (if non-default one exists) to the beginning of the filename
    $newFileName = $theFile -Replace "(.+)$weekly", "$weekly`$1" # looks for non-default regularity and if it finds it, it moves it to the front
    
    Write-Host "Moved Weekly_ if exists`n" -ForegrounfColor Green
    Write-Host $newFileName
    
    # Removes redundant date in filename (if one exists) ## can be changed to look for and replace any other redundant string in the filename 
    $newFileName = $newFileName -Replace "(_\d{1,2}-\d{1,2}-\d{4})\1","`${1}" # date format: mm-dd-yyyy ## adds this date format to the end of the filename
    $newFileName = $newFileName -Replace "(_\d{4}-\d{1,2}-\d{1,2})\1","`${1}" # date format: yyyy-mm-dd ## adds this date format to the end of the filename
     
    Write-Host "Removed redundant date `n" -ForegrounfColor Red
    Write-Host $newFileName
    
    # Adds the name of the child folder to the end of the filename (so you know which folder the renamed file came from)
    $childFolder = $theFile.FullName.Split("\")[-2] # gets the child folder name from the filename by outputting the substring that is 2 \ from the end of the filename
    $newFileName = $newFileName -Replace "$fileExt", "_$childFolder$fileExt" # adds the child folder name to the end of the filename
     
    Write-Host "Added folder name`n" -ForegrounfColor Yellow
    Write-Host $newFileName
    
    # Adds the current date timestamp to the end of the filename
    $newFileName = $newFileName -Replace "$fileExt", "_TS$today$fileExt" # the "TS" is just to show you can add characters too 
     
    Write-Host "Added timestamp`n" -ForegrounfColor Magenta
    Write-Host $newFileName
    
    # Moves country: "ABC CA" (if non-default one exists) to the beginning of the filename
    $newFileName = $newFileName -Replace "(.+)$abcCountry", "$abcCountry`$1" # looks for non-default country name and if it finds it, it moves it to the front
     
    Write-Host "Moved ABC CA if exists`n" -ForegrounfColor Cyan
    Write-Host $newFileName
    
    # Saves the changes of the New filename to the original file
    Rename-Item -Path $theFile.FullName -NewName $newFileName -Force
    
    $originalDirectory = $theFile.Directory # filepath of the original file
    $renamedFilePath = "$originalDirectory\$newFileName" # updated filepath of the renamed file
    
    # Moves files to respective Renamed folder, depending on if it is US or a different country
    if ($newFileName.Contains($nonUSCountryName)) { Move-Item $renamedFilePath -Destination ($importnonUSPath) -Force }
    else { Move-Item $renamedFilePath -Destination ($importUSPath) -Force }
