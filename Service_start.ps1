#Start Service
#Lamboost

#region Parameter
$Dserv = "PC"
$services = "service1", "service2"
$iwaitT = 600
$ELog = ""
$LOGPATH = "Logs_"+ $(get-date -Format yyyy.mm.dd_HH:MM:ss) + "_Service_start.log"
#endregion
#region Service_start
    foreach($service in $services){
        Get-Service -Name $service -ComputerName $Dserv | Start-Service
        while (((Get-Service -Name $service).Status -ne "Running") -and ($i -le $WAIT))
        {
            $i++
            sleep -Seconds 1
        }
        if ((Get-Service -Name $service).Status -ne "Running")
        {
            $heute = Get-Date -Format g
            $ELog = $ELog + $heute +" - Service could not be started: No response in "+ $WAIT +" Seconds`n"
        }
        else{
            $heute = Get-Date -Format g
            $ELog = $ELog + $heute +" - Service was started."
        }
    }
#endregion
#region errorlog
if (!(Test-Path $LOGPATH))
{        
    Foreach($item in $error) 
    {
	    $ELog = $ELog + ($item.Exception.ErrorRecord.InvocationInfo.PositionMessage) +"`n"
    }
    if ($ELog -ne "")
    {
	    $ELog | out-file -FilePath $LOGPATH -Append
    }
}
#endregion

Remove-Variable * -Force -ErrorAction SilentlyContinue
