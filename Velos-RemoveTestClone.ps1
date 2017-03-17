<# 

.DESCRIPTION 
    This runbook deletes a test clone of a virtual machine running in Azure. 
 
.PARAMETER MachineName 
    String name entered for Virtual Machine clone to be removed.

.Notes
    Replace the following before running: vCenter IP address and login, Velostrata appliance IP address and suscription ID, Datacenter ID and target CE name. Datacenter ID can be obtained via PowerShell get-datacenter | select id 
#> 
 
workflow Velos-RemoveTestClone
{    
    # Input parameters 
    param ( 
        # Mandatory parameter of type String
        [parameter(Mandatory=$true)] 
        [string]$MachineName
 

    ) 


    #Print Output based on input parameters
    "Removing Test Clone $MachineName"

#Connect to on premise enviroment and begin move    
InlineScript 
{
    Import-Module 'Velostrata.PowerShell.VMware'
    Import-Module "VMware.VimAutomation.Core" | Out-Null
    connect-viserver 192.168.10.5 -user root -pass password
    $secureString = convertto-securestring "VeolsSubscriptionID"  -asplaintext -force
    Connect-VelostrataManager 192.168.10.20 -username apiuser -password $secureString
    $ce = Get-VelosCe -DatacenterId datacenter-2 -Name "Azure-CE-EastUS"
    Get-VM -Name $using:MachineName | Remove-VelosClone -Confirm:$false -Force
  }


} 
  