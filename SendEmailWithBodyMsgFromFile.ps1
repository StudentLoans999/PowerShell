# This script sends out an email with it's message coming from a TXT file

$username = "david_richey@abc.com"

# readhost -assecurestring | convertfrom-securestring | out-file 

# Extract the password from the password file
$password = get-content "\\ABC-server\Public\Creds\ABCCredentials.txt" | convertto-securestring
$credentials = new-object -typename System.Management.Automation.PSCredential -argumentlsit $username, $password

$body = [string]::Join("`n", (Get-Content "\\ABC-server\Public\Data\Emails\ABCEmail.txt")) # set the contents of the email to be from a TXT file
$date = Get-Date -Format yyyy-MM-dd
$sendTo = "john_smith@def.com"

# Send the email with these configurable attributes
Send-MailMessage `
-Body $body -BodyAsHtml `
-Subject "$date - ABC's Reminder to you: don't worry, be happy" `
-Credential $credentials `
-SmtpServer "smtp-mail.outlook.com" -UseSsl `
-From $username -To $sendTo
