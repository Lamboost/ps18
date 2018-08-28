#Delete Cache folder
#Lamboost
#Vars
$path    = "C:\Tmp"#"C:\Users\EDPService\AppData\Local\Microsoft\Windows\INetCache\IE"
$eventid = 999
$appname = "DelIECache"
#region Function
Function Main{
    try{
        if($(Get-EventLog -LogName Application -Source $appname) -eq $null ){
            New-EventLog –LogName Application –Source $appname 
        }
        Get-ChildItem -Path $path -Include *.* -Recurse | foreach  { $_.Delete()}
        Get-ChildItem -Path $path -Recurse | foreach  { $_.Delete()}
        if($(Get-ChildItem -Path $path -Name).Count -ne 0){
            LogFile "Not all cache files from IE could be deleted. Please check." Error
        } else {
            LogFile "Cache cleared from IE." Information
        }
    } catch {
        LogFile $("[" + $_.InvocationInfo.ScriptLineNumber + "] " + $_.Exception.Message) Error
    }       
}
Function LogFile{
    param([string]$errormess,$Etype)
    Write-EventLog -LogName Application -Source $appname -EntryType $Etype -EventId $eventid -Message $errormess
}
#Start script
Main
