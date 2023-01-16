param([string]$folderPath = "\\ABC-app01\Public\Data\Results\")

# If this script will be run by automation (Windows Scheduler, etc.), add the -NonInteractive switch to prevent the Excel task that runs from hanging 

# Temporary Logging
# Start-Transcript -Path \\ABC-app01\Public\Logs\LogOfMapResultsLog.txt -Append

# If the folder file path is not created through the Parameter in Line 1, enter the File Path here, by replacing $folderPath
$inputFolderName = $folderPath

# Generate the .txt file in \\ABC-app01\Public\Data\Results\ which will be called MapResults_*.txt by running this: CreateMapResultsTXT.bat 
& "C:\Program Files (X86)\
