:: IBM Corporation 
::
:: Vikram Khatri
::
::
:: Run All Commands 
:: 
::

setlocal ENABLEDELAYEDEXPANSION
TITLE RUN00-Build-All.CMD needs to be run only once before imaging laptops
SET LOGFILE="%CD%\RUN00-AllCommands.LOG"
SET SNAPSHOT=STARTOFPOT

@echo off
cls

echo.
echo This scripts needs to be run ONLY ONCE by the TEC professional.
echo.
echo This script will run all commands in sequence to setup 4 virtual machines.
echo It will take 45 minutes (SSD) or 1.5-2 hours (HDD) to complete all commands.
echo.

:getConfirmation

SET /p confirmDeploy=Confirm deployment of the software in VM [y/n] ?:
IF /I "%confirmDeploy%"=="y" GOTO :deployCode
IF /I "%confirmDeploy%"=="n" GOTO :cancelDeploy
GOTO :getConfirmation

:deployCode

ECHO ---------------------------------------------------   >_ && type _ && type _ >  %LOGFILE%
ECHO !TIME! Checking Free Disk Space                       >_ && type _ && type _ >> %LOGFILE%
ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
START /WAIT CMD /C powershell -executionPolicy Bypass .\RUN01-Check-Free-Space.ps1

IF ERRORLEVEL 1 (
    GOTO :end
)

ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
ECHO !TIME! Starting RUN01-RunAsAdmin.ps1                  >_ && type _ && type _ >> %LOGFILE%
ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
START /WAIT CMD /C powershell -executionPolicy Bypass .\RUN02-RunAsAdmin.ps1

IF ERRORLEVEL 1 (
    ECHO "Computer Memory less than 16GB. Aborting ....."
) ELSE (
    ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
    ECHO !TIME! Starting RUN05-CloneBuild.CMD                  >_ && type _ && type _ >> %LOGFILE%
    ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
    START /WAIT CMD /C  RUN05-CloneBuild.CMD

    ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%
    ECHO !TIME! Creating Shortcuts on Desktop                  >_ && type _ && type _ >> %LOGFILE%
    START /WAIT CMD /C  RUN07-Create-Desktop-Shortcut.CMD
    ECHO ---------------------------------------------------   >_ && type _ && type _ >> %LOGFILE%

    ECHO !TIME! Ending                                         >_ && type _ && type _ >> %LOGFILE%
    DEL _ 2>NUL
    ECHO.
    ECHO ---------------------------------------------------
    ECHO Note: Please check %LOGFILE% carefully.
    ECHO ---------------------------------------------------

    GOTO :end
)

:cancelDeploy
ECHO !TIME! DEPLOY CANCELLED                                  >_ && type _ && type _ >> %LOGFILE%

:end
DEL _  2>NUL
DEL _z 2>NUL
