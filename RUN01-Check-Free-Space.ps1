<#
:: IBM Corporation 
::
:: Vikram Khatri
::
::
:: Calculate Free disk space to avoid problems later.
::
#>

$curDir = $myinvocation.MyCommand.Definition | split-path -parent
$LOGFILE=$curDir+"\RUN00-AllCommands.LOG"

$spacereq=100
$drive=(Get-Item .).PSDrive.Name
$freespace=Get-WMIObject Win32_Logicaldisk -filter "deviceid='${drive}:'" | % {$_.FreeSpace}
$freegb=[int]($freespace/(1024*1024*1024))
add-content -Path $LOGFILE -Value  "The disk free space is $freegb GB" -Force

if ($freegb -lt $spacereq)
{
   add-content -Path $LOGFILE -Value  "The disk free space is $freegb GB and we need $spacereq GB for the VM. Exiting..." -Force
   write-host "The disk free space is $freegb GB"
   write-host "We need minimum $spacereq GB for the VM."
   write-host "Please free-up space or use another drive"
   Write-Host "Press any key to continue ..."
   $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
   exit 1
} else {
   write-host "The disk free space is $freegb GB"
} 
exit 0  
