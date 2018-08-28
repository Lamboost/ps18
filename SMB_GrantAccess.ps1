# SMB Grant Access
# Lamboost, 16.10.2017
# Vars
$nl   = [Environment]::NewLine
$sharename = "DIR"
$sharepath = "D:\DIR"
$ebody = "Everyone"
$access = "user1, user2"
$mailto = "your email"
$mailfrom = "info@email.com"
$mailsubjct = "SMB Grant Access"
$mailbody = 
"Access to Share '" + $sharename + "'(" + $sharepath + ") is free." + $nl + 
"All users have access now."+ $nl + $nl + 
"Greetings" + $nl + "Admin"
$mailrelay = "smtp Server"
$MyDir = Split-Path $script:MyInvocation.MyCommand.Path
$time = Get-Date -Format yyyyMMdd_HHmmss
$logfile = $MyDir+"\log\"+$time + "Kitoffice_wartung.log"
Get-WmiObject -Class Win32_Share
# Functions
function MAIN{
    try{
        Logfile  "Maintenance carried out. Allow all users again."
        #Remove old share
        RMShare  $sharename $access
        #Create new share
        NEWShare $name $ebody
        SENDMail $mailto $mailfrom $mailsubjct $mailbody $mailrelay
        Logfile  "All users are authorized again."
    }
    Catch [exception] {
        Logfile $("[" + $_.InvocationInfo.ScriptLineNumber + "] " + $_.Exception.Message)
    }
}
function RMShare(){
    param([string]$name,[string]$user)
    Logfile $($name + " Delete Share Access")
    Revoke-SmbShareAccess -name $name -Force
}
function NEWShare(){
    param([string]$name,[string]$user)
    Logfile $($path + "create new Share Access")
    Grant-SmbShareAccess -Name $name -AccountName $user -AccessRight Change -Force
}
function SENDMail(){
    param([string]$tomail,[string]$frommail,[string]$subject,[string]$body,[string]$smtp)
    Logfile $("EMail " + $subject + " to " + $tomail + " mailed")
    Send-MailMessage -to $tomail -from $frommail -Subject $subject -body $body -SmtpServer $smtp
}
function Logfile(){
    param([string]$errormess)
    $("[" + $(Get-Date -Format HH:mm:ss) + "] " + $errormess) | Add-Content $logfile
}
#Start script
Main
