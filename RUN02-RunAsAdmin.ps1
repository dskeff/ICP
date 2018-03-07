<#
:: IBM Corporation 
::
:: Vikram Khatri 
::
::
:: This is a driver PowerShell Script to run another script in an elevated shell
:: If UAC is turned on, a pop-up will appear "Do you want to allow this program to make changes to this computer" 
:: and click YES to allow to run the script.
::
#>

$curDir = $myinvocation.MyCommand.Definition | split-path -parent
$LOGFILE=$curDir+"\RUN00-AllCommands.LOG"

add-content -Path $LOGFILE -Value  "Launching PowerShell in an elevated shell" -Force

$fixmemoryscript="RUN03-FixVMMemory.ps1"

add-content -Path $LOGFILE -Value  "Value of CurDir $curDir" -Force
add-content -Path $LOGFILE -Value  "Launching PowerShell in an elevated shell for $fixmemoryscript" -Force

$relaunchArg = '-executionpolicy unrestricted -file "' + $curDir + "\" + $fixmemoryscript + '"'

try
{
	$AdminProcess = Start-Process PowerShell -Verb RunAs -ArgumentList $relaunchArg -PassThru
}
catch
{
	add-content -Path $LOGFILE -Value  "$Error[0]" -Force
	exit 1
}

# Wait until the elevated process terminates
while (!($AdminProcess.HasExited))
{
	Start-Sleep -Seconds 2
}
exit 0