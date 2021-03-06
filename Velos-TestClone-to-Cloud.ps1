<# 

.DESCRIPTION 
    This runbook creates a clone of a virtual machine from vSphere into Azure using Velostrata. 
 
.PARAMETER MachineName 
    String name entered for Virtual Machine to be moved
 
.PARAMETER  Instance 
    String name for Azure instance type to be used
 
.Notes
    Replace the following before running: vCenter IP address and login, Velostrata appliance IP address and suscription ID, Datacenter ID and target CE name. Datacenter ID can be obtained via PowerShell get-datacenter | select id
#> 
 
workflow Velos-TestClone-to-Cloud
{    
    # Input parameters 
    param ( 
        # Mandatory parameter of type String 
        [parameter(Mandatory=$true)] 
        [string]$MachineName, 
 
         # Optional parameter of type String, default value "Standard_A3" 
        [parameter(Mandatory=$false)] 
        [string]$Instance = "Standard_A3"

    ) 


    #Print Output based on input parameters
    "Cloning $MachineName to instance type $Instance"

#Connect to on premises enviroment and begin move    
InlineScript 
{
    Import-Module 'Velostrata.PowerShell.VMware'
    Import-Module "VMware.VimAutomation.Core" | Out-Null
    Connect-VIServer -Server 192.168.10.5 -user root -pass password -errorAction Stop
    $secureString = convertto-securestring "VeolsSubscriptionID" -asplaintext -force
    Connect-VelostrataManager 192.168.10.20 -username apiuser -password $secureString
    $ce = Get-VelosCe -DatacenterId datacenter-2 -Name "Azure-CE-EastUS"
    Get-VM -Name $using:MachineName | New-VelosClone -CloudExtension $ce -InstanceType $Using:Instance -EdgeNode NodeA
  }


} 
  