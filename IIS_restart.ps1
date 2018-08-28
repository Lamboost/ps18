<#
.SYNOPSIS
    IIS Dienste neustarten
.DESCRIPTION
    IIS Service neustarten mit E-Mail Benachrichtigung
.NOTES
    File Name      : IIS_restart.ps1
    Author         : Lamboost
.EXAMPLE
    -
#>
#Vars
$srvname    = "PC"
$appname    = "IIS RESTART"
$smtp       = "smtp Server"
$appsrce    = "IIS_restart.ps1"
$EMail      = "Your Email"
$sender     = "INFO@mail.com"
$eventid    = 999
$wait       = 60
$MyDir      = Split-Path $script:MyInvocation.MyCommand.Path
$log        = $MyDir+"\log\"+$(Get-Date -Format yyyyMMdd-hhmm) + "_" +"IIS-Restart.log"
$iisreset   = "C:\Windows\System32\iisreset.exe"
if($(Get-EventLog -LogName Application -Source $appname) -eq $null){
    New-EventLog –LogName Application –Source $appname
}

#Functions
Function Main{
    try{
        Logfile "IIS Dienste beenden." Information
        Start-Process -FilePath $iisreset -ArgumentList "/STOP" -RedirectStandardOutput $Outputstop
        Logfile $Outputstop Information
        Start-Sleep -Seconds $wait
        Logfile "IIS Dienste wurden beendet. 1 Minuten warten." Information
        Start-Process -FilePath $iisreset -ArgumentList "/START" -RedirectStandardOutput $Outputstart
        Logfile $Outputstart Information
        Logfile "IIS Dienste wurde wieder gestartet." Information
    } catch {
        WriteEventaMail $("[" + $_.InvocationInfo.ScriptLineNumber + "] " + $_.Exception.Message) "Neustartfehler bei IIS" Error
    }
}
Function WriteEventaMail {
    param([string]$message,[string]$title, $entrytypeM)
    try{
        Write-EventLog -LogName Application -Source $appname -EntryType $entrytypeM -EventId $eventid -Message $message
        Send-MailMessage -to $EMail -from $sender -Subject $title -body $message -SmtpServer $smtp
        Logfile $message $entrytypeM
    } catch {
        LogFile $("[" + $_.InvocationInfo.ScriptLineNumber + "] " + $_.Exception.Message) Error
    }
}
Function LogFile{
    param([string]$errormess, $entrytype)
    Write-EventLog -LogName Application -Source $appname -EntryType $entrytype -EventId $eventid -Message $errormess
    $("[" + $(Get-Date -Format HH:mm:ss) + "] " + $errormess) | Add-Content $log
}
#Skript starten
Main
