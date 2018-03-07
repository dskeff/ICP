:: IBM Corporation 
::
:: Vikram Khatri
::
::
:: Create Shortcuts on Windows desktop
::

@ECHO OFF
cls
 
%windir%\system32\cmd.exe /C "START /WAIT CScript RUN07-Create-Desktop-Shortcut.vbs //NoLogo"
