:: IBM Corporation
::
:: Vikram Khatri
::
:: Prerequisite: (Important - Please READ)
:: Start your VMWare workstation and check if your version is 12.0.1 or later.


setlocal ENABLEDELAYEDEXPANSION
SET LOGFILE="%CD%\RUN00-AllCommands.LOG"
@echo off
cls

SET VMRUN="C:\Program Files (x86)\VMware\VMware VIX\vmrun.exe"
SET ROOTPWD=password

IF EXIST %VMRUN% (
  ECHO !TIME! Copying icp02\icp02.vmdk to icp03                        >_z && type _z && type _z >> %LOGFILE%
  copy icp02\icp02.vmdk icp03\icp03.vmdk /v /y 
  ECHO !TIME! Copying icp02\icp02.vmdk to icp04                        >_z && type _z && type _z >> %LOGFILE%
  copy icp02\icp02.vmdk icp04\icp04.vmdk /v /y
  ECHO !TIME! Copying icp02\icp02.vmdk to icp05                        >_z && type _z && type _z >> %LOGFILE%
  copy icp02\icp02.vmdk icp05\icp05.vmdk /v /y

  REM ECHO !TIME! Copying icp01\gpfs.vmdk to icp02                         >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\gpfs.vmdk icp02\gpfs.vmdk /v /y 
  REM ECHO !TIME! Copying icp01\gpfs.vmdk to icp03                         >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\gpfs.vmdk icp03\gpfs.vmdk /v /y
  REM ECHO !TIME! Copying icp01\gpfs.vmdk to icp04                         >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\gpfs.vmdk icp04\gpfs.vmdk /v /y
  REM ECHO !TIME! Copying icp01\gpfs.vmdk to icp05                         >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\gpfs.vmdk icp05\gpfs.vmdk /v /y

  REM ECHO !TIME! Copying icp01\dockerbackend.vmdk to icp02            >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\dockerbackend.vmdk icp02\dockerbackend.vmdk /v /y 
  REM ECHO !TIME! Copying icp01\dockerbackend.vmdk to icp03            >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\dockerbackend.vmdk icp03\dockerbackend.vmdk /v /y
  REM ECHO !TIME! Copying icp01\dockerbackend.vmdk to icp04            >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\dockerbackend.vmdk icp04\dockerbackend.vmdk /v /y
  REM ECHO !TIME! Copying icp01\dockerbackend.vmdk to icp05            >_z && type _z && type _z >> %LOGFILE%
  REM copy icp01\dockerbackend.vmdk icp05\dockerbackend.vmdk /v /y

  ECHO !TIME! Copying icp01\gluster.vmdk to icp02                      >_z && type _z && type _z >> %LOGFILE%
  copy icp01\gluster.vmdk icp02\gluster.vmdk /v /y 
  ECHO !TIME! Copying icp01\gluster.vmdk to icp03                      >_z && type _z && type _z >> %LOGFILE%
  copy icp01\gluster.vmdk icp03\gluster.vmdk /v /y
  ECHO !TIME! Copying icp01\gluster.vmdk to icp04                      >_z && type _z && type _z >> %LOGFILE%
  copy icp01\gluster.vmdk icp04\gluster.vmdk /v /y
  ECHO !TIME! Copying icp01\gluster.vmdk to icp05                      >_z && type _z && type _z >> %LOGFILE%
  copy icp01\gluster.vmdk icp05\gluster.vmdk /v /y

  ECHO ---------------------------------------------------             >_ && type _ && type _ >> %LOGFILE%
  ECHO !TIME! Starting RUN06-TakeSnapshot.CMD                          >_ && type _ && type _ >> %LOGFILE%
  ECHO.
  ECHO !TIME! Taking snapshot %SNAPSHOT% for icp01          >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% snapshot "icp01\icp01.vmx" %SNAPSHOT%
  ping -n 2 127.0.0.1>nul 
  ECHO !TIME! Taking snapshot %SNAPSHOT% for icp02          >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% snapshot "icp02\icp02.vmx" %SNAPSHOT%
  ping -n 2 127.0.0.1>nul
  ECHO !TIME! Taking snapshot %SNAPSHOT% for icp03          >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% snapshot "icp03\icp03.vmx" %SNAPSHOT%
  ping -n 2 127.0.0.1>nul
  ECHO !TIME! Taking snapshot %SNAPSHOT% for icp04          >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% snapshot "icp04\icp04.vmx" %SNAPSHOT%
  ECHO !TIME! Taking snapshot %SNAPSHOT% for icp05          >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% snapshot "icp05\icp05.vmx" %SNAPSHOT%
  ping -n 2 127.0.0.1>nul
  ECHO ---------------------------------------------------             >_ && type _ && type _ >> %LOGFILE% 

  ECHO !TIME! Starting icp01                                           >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T ws start "icp01\icp01.vmx"
  ping -n 120 127.0.0.1>nul
  ECHO !TIME! Starting icp02                                           >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T ws start "icp02\icp02.vmx"
  ping -n 120 127.0.0.1>nul
  ECHO !TIME! Starting icp03                                           >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T ws start "icp03\icp03.vmx"
  ping -n 120 127.0.0.1>nul
  ECHO !TIME! Starting icp04                                           >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T ws start "icp04\icp04.vmx"
  ping -n 120 127.0.0.1>nul
  ECHO !TIME! Starting icp05                                           >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T ws start "icp05\icp05.vmx"
  ping -n 120 127.0.0.1>nul

  ECHO !TIME! Wait for Clone and Install to complete                   >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% -T -ws -gu root -gp %ROOTPWD% runScriptInGuest "icp01\icp01.vmx" /bin/bash "/root/bin/setup/waitInstall > /tmp/waitInstall.log  2>&1"  

  ECHO !TIME! Power down icp05                                         >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% stop "icp05\icp05.vmx" hard
  ping -n 10 127.0.0.1>nul
  ECHO !TIME! Power down icp04                                         >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% stop "icp04\icp04.vmx" hard
  ping -n 10 127.0.0.1>nul
  ECHO !TIME! Power down icp03                                         >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% stop "icp03\icp03.vmx" hard
  ping -n 10 127.0.0.1>nul
  ECHO !TIME! Power down icp02                                         >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% stop "icp02\icp02.vmx" hard
  ping -n 10 127.0.0.1>nul
  ECHO !TIME! Power down icp01                                         >_z && type _z && type _z >> %LOGFILE%
  %VMRUN% stop "icp01\icp01.vmx" hard
  ECHO At the end   !TIME!                                             >_z && type _z && type _z >> %LOGFILE%

  ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
  ECHO !TIME! Creating Shortcuts on Desktop                  >_ && type _ && type _ >> %LOGFILE%
  START /WAIT CMD /C  RUN06-Create-Desktop-Shortcut.CMD
  ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%

  ECHO !TIME! Ending                                         >_ && type _ && type _ >> %LOGFILE%
  DEL _ 2>NUL
  ECHO.
  ECHO ---------------------------------------------------
  ECHO Note: Please check %LOGFILE% carefully.
  ECHO ---------------------------------------------------
  DEL _z && DEL _
) ELSE (
  ECHO The vmrun is not in its default location.
  ECHO Please locate it and update SET VMRUN in this file and run 
  ECHO this command again.
  ECHO.
)