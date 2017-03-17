<# 

.DESCRIPTION 
    This runbook moves a virtual machine from Azure back its origin in vSphere using Velostrata. 
 
.PARAMETER MachineName 
    String name entered for Virtual Machine to be moved
 
.Notes
    Replace the following before running: vCenter IP address and login, Velostrata appliance IP address and suscription ID, Datacenter ID and target CE name. Datacenter ID can be obtained via PowerShell get-datacenter | select id
 
#> 
 
workflow Velos-Run-On-Premise
{    
    # Input parameters 
    param ( 
        # Mandatory parameter of type String 
        [parameter(Mandatory=$true)] 
        [string]$MachineName

    ) 

    #Print Output based on input parameters
    "Moving $MachineName to on premise."

#Connect to on-premises environment to move back
InlineScript 
{
    Import-Module 'Velostrata.PowerShell.VMware'
    Import-Module "VMware.VimAutomation.Core" | Out-Null
    connect-viserver 192.168.10.5 -user root -pass password
    $secureString = convertto-securestring "VelosSubscriptionID" -asplaintext -force
    Connect-VelostrataManager 192.168.10.20 -username apiuser -password $secureString
    $ce = Get-VelosCe -DatacenterId datacenter-2 -Name "Azure-CE-EastUS"
    Get-VM -name $using:MachineName | Move-VelosVm -Destination Origin Confirm:$false -force 
  }


} 