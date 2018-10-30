# PRTG-PANOS
PRTG Sensors  for PANOS

#### Tunnel State
Security associations (SAs) are not exposed via SNMP; they are only available from the web interface, CLI and XML API. This script allows polling of SA state from PRTG using a PowerShell extension. The script has the following requirements:

1. A standard naming convention - The IKE Gateway and IPSEC Tunnel objects for a given tunnel should have the same name. For example, for tunnel with a third party, I prefer "partner-x.x.x.x", where parnter is the third party and x.x.x.x is the IP address.

2. Trusted SSL certifiate - The device should present a trusted certificate for the API request to avoid PowerShell gymnastics to disable certificate validation as the supported method varies with version of PowerShell. 

3. Lookup Table - An XML-based lookup table to define the sensor's channel information.
*  0 - Down
*  1 - Phase 1
*  2 - Phase 2

Note: It is not unusual for a tunnel to have a Phase 2 SA without a Phase 1 SA on PANOS. In this instance the script will reflect the Phase 2 SA.

#### Installation

1. Copy the script to C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
2. Copy the lookup to C:\Program Files (x86)\PRTG Network Monitor\lookups
3. Reload lookups (Setup -> Administrative Tools -> Load Lookups and File Lists)
4. When defining the EXE/Script Advanced Sensor, specify the following:
* EXE/Script:  Script name from  the drop-down 
* Paramters: %host %linuxpassword (I use the parent's otherwise unused Linux Password field to securely store the API key)
