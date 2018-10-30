#Sensors -> Settings -> Parameters, ex. '%host %linuxpassword'
Param ($Device, $Device_Key)

#Gateway -> State: 0 - Down, 1 - Phase1, 2 - Phase2
$Gateways = @{}

try {
  #Definfed gateways
  $URL = "https://$($Device)/api/?type=op&cmd=<show><vpn><gateway></gateway></vpn></show>&key=$($Device_Key)"
  $Result = Invoke-RestMethod -Uri $URL -Method Get
  $Result.response.result.entries.entry.name | ForEach-Object { $Gateways.Set_Item($_, 0) }

  #Phase 1 SA status
  $URL = "https://$($Device)/api/?type=op&cmd=<show><vpn><ike-sa></ike-sa></vpn></show>&key=$($Device_Key)"
  $Result = Invoke-RestMethod -Uri $URL -Method Get
  $Result.response.result.entry.name | ForEach-Object { $Gateways.Set_Item($_, 1) }

  #Phase 2 SA status
  $URL = "https://$($Device)/api/?type=op&cmd=<show><vpn><ipsec-sa></ipsec-sa></vpn></show>&key=$($Device_Key)"
  $Result = Invoke-RestMethod -Uri $URL -Method Get
    $Result.response.result.entries.entry.name | ForEach-Object {
    If ($_ -match ':') {
        $Gateways.Set_Item($_.SubString(0, $_.IndexOf(':')), 2)
    } Else {
        $Gateways.Set_Item($_, 2)
    }
  }

  Write-Output '<prtg>'
  $Gateways.Keys | ForEach-Object {
    Write-Output "<result>`n<channel>$($_)</channel>"
    Write-Output "<value>$($Gateways.$_)</value>"
    Write-Output '<ValueLookup>oid.panos.vpnPeerTable</ValueLookup>'
  }
  Write-Output '</prtg>'
} catch {
@"
<prtg>
<error>1</error>
<text>$($_.Exception.Message)</text>
</prtg>
"@
}
