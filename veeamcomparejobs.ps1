#Connect vCenter
 
If ($Cred -eq $null)
{
$cred = get-credential
}
If ($vcenter -eq $null){
$vcenter = Read-Host  -Prompt 'Enter vCenter Server Name'
}
$vi = connect-viserver $vcenter -credential $cred
 
#Connect to Veeam
 
If ($vbrserver -eq $null){
$vbrserver = Read-Host  -Prompt 'Enter Veeam Server name'
} 
Connect-VBRServer -server $vbrserver

#Compare VMs in Inventory to Backup Jobs
 
$backupjobs = get-vbrjob | where-object {$_.JobTargetType -eq "Backup"} | select -expandproperty Name
$prodvms = get-cluster | where-object {$_.Name -match "cluster1|cluster2"} | get-vm | sort-object | select -expandproperty Name
$differencevms = $prodvms | where {$backupjobs -notcontains $_} | sort-object | out-file c:\test\prodvmsdiff.txt