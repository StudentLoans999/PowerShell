# This checks for TXT files that are less than 5 Lines long, if so, then the file gets deleted, if not, do X process
$checkThisFolder = "\\ABC-server\Public\Data\Files\CheckForLength"
$fileFilter = "*ABC*.txt"

Get-ChildItem -Path $checkThisFolder -Filter $fileFilter | Foreach-Object
{
  $theCount = (Get-Content $_.FullName | Measure-Object -Line) # could do other things with Measure-Object like -Characters
  
  if ($theCount.Lines -lt 5)
  {
    # Delete the nearly empty file:
    Write-Output "Deleting " + $_.FullName
    Remove-Item -Path $_.FullName
  }
  
  else
  {
  # Do X process here if the file has more than 4 lines in it
  }
}
