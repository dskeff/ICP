Option Explicit 

Dim objShell
Dim objDesktop
Dim  objLink
Dim strAppPath
Dim strWorkDir
Dim strIconPath 
Dim strCurDir
Dim filesys

strWorkDir ="C:\"
strAppPath = "http://192.168.142.101:9300"
set objShell = CreateObject("WScript.Shell")
strCurDir = objShell.CurrentDirectory
rem strIconPath = strCurDir & "\icp01\dsm.ico"
objDesktop = objShell.SpecialFolders("Desktop")
Set objLink = objShell.CreateShortcut(objDesktop & "\IBM Cloud Private Web Console.lnk") 
objLink.Description = "IBM Cloud Private Web Console"
objLink.HotKey = "CTRL+SHIFT+D"
objLink.IconLocation = strIconPath 
objLink.TargetPath = strAppPath
objLink.WindowStyle = 3
objLink.WorkingDirectory = strWorkDir
objLink.Save

Set filesys=CreateObject("Scripting.FileSystemObject")
filesys.CopyFile "console13.sql", objDesktop & "\console13.sql"
filesys.CopyFile "query01.sql", objDesktop & "\query01.sql"

WScript.Quit