# Script Written by Drew Burgess 12/19/2021
Function TEST-RPCSERVER {
    cls
    
    $LocalHost = $env:COMPUTERNAME
    
    $theinfo = "$LocalHost" 
    
    [System.Int16]$port = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("MTM1"))
    
    $rpcsscheckport = Test-NetConnection -ComputerName $theinfo -Port $port -ErrorAction Ignore | Select TcpTestSucceeded
    
    $rpcstatus    = Invoke-Command -ComputerName $theinfo -ScriptBlock { get-service -Name "rpcss" | Select Status }

    If (($rpcsscheckport -and "True") -and (($rpcstatus) -and "Running")) {
    
        Write-Host "`nRPC Server is running on remote host : $theinfo" -ForegroundColor Green -BackgroundColor Black

    }
    Else {
    
        # If RPC port is open
    
        If ($rpcsscheckport -and "True") {
        
            Write-Host "`nStarting Rpc Server on remote host " -ForegroundColor DarkYellow -BackgroundColor Black
        
            Invoke-Command -ComputerName $theinfo -ScriptBlock { Restart-Service "RpcSs" } -WarningAction Ignore -ErrorAction Ignore

        }
    }

}

TEST-RPCSERVER