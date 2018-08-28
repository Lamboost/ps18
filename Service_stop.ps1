#Stop Service
#Lamboost 

#region Parameter
$Dserv = "PC"
$services = "server1", "server2"
$iwaitT = 600
$ELog = ""
$LOGPATH = "Logs_"+ $(get-date -Format yyyy.mm.dd_HH:MM:ss) + "_Service_stop.log"
#endregion
#region Service_stop
    foreach($service in $services){
        $i = 0
        Get-Service -Name $service -ComputerName $Dserv | Stop-Service
        while (((Get-Service -Name $service).Status -ne "Stopped") -and ($i -le $WAIT))
        {
            $i++
            sleep -Seconds 1
        }
        if ((Get-Service -Name $service).Status -eq "Stopped")
        {
            $heute = Get-Date -Format g
            $ELog = $ELog + $heute +" - Service was terminated."
        } 
        else
        {
            $heute = Get-Date -Format g
            $ELog = $ELog + $heute +" - Service could not be terminated: No response in "+ $WAIT +" Seconds`n"
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
