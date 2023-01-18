$filesLookingFor = Get-ChildItem "\\ABC-app01\Public\Data\Files\*ABC*.txt" # can also use "gci" isntead of "Get-ChildItem"
$count = 1

ForEach ($file in $filesLookingFor)
{
  $contents = import-csv $file -Delimiter "`t"
  $newName = [System.IO.Path]::GetDirectoryName($file.FullName) + "\" + "DEF.csv" -f (Get-Date).ToString("yyyyMMdd_HHmmss"), $count
  
  ForEach ($line in $contents) { $line.Day_Code = (Get-Date $line.Day_Code).ToString("yyyy-MM-dd") }
  
  $contents | export-csv -Path ($newName + "_1") -Delimiter "," -NoClobber -NoTypeInformation
  
  Get-Content ($newName + "_1") | % { $_ -replace '"','' } | Set-Content $newName
  
  $count += 1
}
