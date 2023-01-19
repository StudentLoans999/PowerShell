# This script sends out an email to multiple people with attachments coming from a TXT file and a XLSX file

$username = "david_richey@abc.com"

# readhost -assecurestring | convertfrom-securestring | out-file "\\ABC-app01\Public\Creds\ABCCredentials.txt

# Extract the password from the password file
$password = get-content "\\ABC-app01\Public\Creds\ABCCredentials.txt" | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlsit $username, $password

$body = "I have attached two files."
$fileFilter1 = *ABC*.txt
$fileFilter1 = *ABC*.xlsx
$attachment1 = Get-ChildItem "\\ABC-app01\Public\Data" -filter $fileFilter1
$attachment2 = Get-ChildItem "\\ABC-app01\Public\Data" -filter $fileFilter2
$subject = "Important documents enclosed"
$sendTo = "john_smith@def.com"

# Send the email with these configurable attributes
Send-MailMessage `
-Body $body `
-Attachments $attachment1,FullName, $attachment2.FullName `
-Subject $subject `
-Credential $credentials `
-SmtpServer "smtp-mail.outlook.com" -UseSsl `
-From $username -To $sendTo
