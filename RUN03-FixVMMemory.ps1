<#
:: IBM Corporation 
::
:: Vikram Khatri
::
::
:: PowerShell Script that calculates memory for each VM and modifies memsize in each VMX file 
:: This requires to run in an elevated shell
:: Windows Management Intrumentation service should be up and running to calculate installed memory in the machine
::
#>

function getMemory4
{
   Param ([int]$mem)
   return $mem - ($mem % 4)
}

$vmscript = "RUN04-FixVMNetAddress.CMD"
$scpath = $myinvocation.MyCommand.Definition | split-path -parent
$LOGFILE=$scpath+"\RUN00-AllCommands.LOG"
$PDIR=$scpath

$P1=$PDIR + "\icp01\icp01.vmx"
$P2=$PDIR + "\icp02\icp02.vmx"
$P3=$PDIR + "\icp03\icp03.vmx"
$P4=$PDIR + "\icp04\icp04.vmx"
$P5=$PDIR + "\icp05\icp05.vmx"

add-content -Path $LOGFILE -Value  "Value of P1 $P1" -Force
add-content -Path $LOGFILE -Value  "Value of P2 $P2" -Force
add-content -Path $LOGFILE -Value  "Value of P3 $P3" -Force
add-content -Path $LOGFILE -Value  "Value of P4 $P4" -Force
add-content -Path $LOGFILE -Value  "Value of P5 $P5" -Force

Set-Service -name winmgmt -startupType Automatic
Start-Service winmgmt
# Works on Windows 7
$array=get-wmiobject -class "win32_physicalmemory" -namespace "root\CIMV2" | % {$_.Capacity}
# Works on Windows 8
#$array=get-ciminstance -class "cim_physicalmemory" | % {$_.Capacity}

$mem=($array | Measure-Object -Sum).sum
$memgb=$mem/(1024*1024*1024)

add-content -Path $LOGFILE -Value "Total physical memory on host $env:COMPUTERNAME is $memgb GB" -Force

#$memgb=16
#$mem=(1024*1024*1024*$memgb)

if ($memgb -lt 16)
{
   add-content -Path $LOGFILE -Value  "Minimum 16 GB RAM is required to run 4 VMware pureScale machines" -Force
   add-content -Path $LOGFILE -Value  "Aborting ...." -Force
   exit 1
} elseif ($memgb -eq 16)
{
   [int]$memps1=getMemory4 ($mem*0.200/(1024*1024))
   [int]$memps2=getMemory4 ($mem*0.160/(1024*1024))
   [int]$memps3=getMemory4 ($mem*0.160/(1024*1024))
   [int]$memps4=getMemory4 ($mem*0.160/(1024*1024))   
   [int]$memps5=getMemory4 ($mem*0.160/(1024*1024))   
} elseif ($memgb -gt 16 -or $memgb -le 32)
{
   [int]$memps1=getMemory4 ($mem*0.200/(1024*1024))
   [int]$memps2=getMemory4 ($mem*0.150/(1024*1024))
   [int]$memps3=getMemory4 ($mem*0.150/(1024*1024))
   [int]$memps4=getMemory4 ($mem*0.150/(1024*1024))   
   [int]$memps5=getMemory4 ($mem*0.150/(1024*1024))   
} else
{
   [int]$memps1=getMemory4 ($mem*0.200/(1024*1024))
   [int]$memps2=getMemory4 ($mem*0.120/(1024*1024))
   [int]$memps3=getMemory4 ($mem*0.120/(1024*1024))
   [int]$memps4=getMemory4 ($mem*0.120/(1024*1024))   
   [int]$memps5=getMemory4 ($mem*0.120/(1024*1024))   
}

add-content -Path $LOGFILE -Value  "Calculated memory for Node01 pureScale is $memps1 MB" -Force
add-content -Path $LOGFILE -Value  "Calculated memory for Node02 pureScale is $memps2 MB" -Force
add-content -Path $LOGFILE -Value  "Calculated memory for Node03 pureScale is $memps3 MB" -Force
add-content -Path $LOGFILE -Value  "Calculated memory for Node04 pureScale is $memps4 MB" -Force
add-content -Path $LOGFILE -Value  "Calculated memory for Node05 pureScale is $memps5 MB" -Force

add-content -Path $LOGFILE -Value  "Changing $P1 memory to $memps1 MB" -Force
(Get-Content ($P1)) | % {$_ -replace '^memsize = .+$', ("memsize = " + '"'+$memps1+'"')} | Set-Content  ($P1)

add-content -Path $LOGFILE -Value  "Changing $P2 memory to $memps2 MB" -Force
(Get-Content ($P2)) | % {$_ -replace '^memsize = .+$', ("memsize = " + '"'+$memps2+'"')} | Set-Content  ($P2)

add-content -Path $LOGFILE -Value  "Changing $P3 memory to $memps3 MB" -Force
(Get-Content ($P3)) | % {$_ -replace '^memsize = .+$', ("memsize = " + '"'+$memps3+'"')} | Set-Content  ($P3)

add-content -Path $LOGFILE -Value  "Changing $P4 memory to $memps4 MB" -Force
(Get-Content ($P4)) | % {$_ -replace '^memsize = .+$', ("memsize = " + '"'+$memps4+'"')} | Set-Content  ($P4)

add-content -Path $LOGFILE -Value  "Changing $P5 memory to $memps5 MB" -Force
(Get-Content ($P5)) | % {$_ -replace '^memsize = .+$', ("memsize = " + '"'+$memps5+'"')} | Set-Content  ($P5)

add-content -Path $LOGFILE -Value  "Running script RUN04-FixVMNetAddress.CMD to change the network address" -Force

$cmd = $scpath + '\' + $vmscript

Write-Host "Running $cmd to set the vmnet addresses"

CMD /C $cmd >> $LOGFILE

exit 0
