<# 

.DESCRIPTION 
    This runbook migrates a virtual machine from vSphere to Azure using Velostrata
 
.PARAMETER MachineName 
    String name entered for Virtual Machine to be migrated
 
.PARAMETER  Instance 
    String name for Azure instance type to be used

.PARAMETER  EdgeNode 
    String name for Velostrata Edge Node to be used

 .Notes
    Replace the following before running: vCenter IP address and login, Velostrata appliance IP address and suscription ID, Datacenter ID and target CE name, and Azure storage account. Datacenter ID can be obtained via PowerShell get-datacenter | select id 
#> 
 
workflow Velos-Migrate-To-Cloud
{    
    # Input parameters 
    param ( 
        # Mandatory parameter of type String
        [parameter(Mandatory=$true)] 
        [string]$MachineName, 
 
         # Mandatory parameter of type String 
        [parameter(Mandatory=$true)] 
        [string]$Instance,

         # Optional parameter of type String, default value "NodeA" 
        [parameter(Mandatory=$false)] 
        [string]$EdgeNode = "NodeA"
    ) 


    #Print Output based on input parameters
    "Migrating $MachineName to instance type $Instance"
    
#Connect to on premise enviroment and begin migration      
InlineScript 
{
    Import-Module 'Velostrata.PowerShell.VMware'
    Import-Module "VMware.VimAutomation.Core" | Out-Null
    Connect-VIServer -Server 192.168.10.5 -user root -pass password -errorAction Stop
    $secureString = convertto-securestring VeolsSubscriptionID -asplaintext -force
    Connect-VelostrataManager 192.168.10.20 -username apiuser -password $secureString
    $ce = Get-VelosCe -DatacenterId datacenter-2 -Name "Azure-CE-EastUS"
    Get-VM -Name $using:MachineName | Invoke-VelosMigration -CloudExtension $ce -InstanceType $Using:Instance -EdgeNode $Using:EdgeNode -StorageSpec StorageAccountName
  }


} 