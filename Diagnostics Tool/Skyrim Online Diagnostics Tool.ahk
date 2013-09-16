; ------- 
; Created by Jarl Gullberg (Jargon) for use with the Skyrim Online Mod
; This work is distributed under the following license : http://creativecommons.org/licenses/by-nc-sa/3.0/
; -------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include SmartZip.ahk

;;;-------;;;
Gui, Add, Text,, Skyrim Online Diagnostics Tool - v1.3
Gui, Font, underline
Gui, Add, Text, gAbout x610 y6, About
Gui, Font, norm
; Add listview where info appears
Gui, Add, ListView, x10 y25 r20 w630, Requirement|Status
; Create all buttons in GUI 1
Gui, Add, Button, default gButtonScan, Scan
Gui, Add, Button, gOpenForums, Forums
Gui, Add, Button, gDownloadDrivers, Download appropriate drivers
Gui, Add, Button, gInstallDotNet, Install .Net Framework 4.5
Gui, Add, Button, gInstallRedist, Download Visual Studio 2012 x86 Redistributable
Gui, Add, Button, gRepairInstallation, Attempt to repair installation
Gui, Add, Button, gInstallSKSE, Repair SKSE Installation
Gui, Add, Button, gRepairScriptDragon, Repair ScriptDragon
Gui, Add, Button, gExitTool, Exit
; Create all elements GUI 2
Gui, 2:Add, Text,, Created by Jarl Gullberg - © 2013
Gui, 2:Add, Text, w200 h225, This tool is released under the by-nc-sa 3.0 Creative Commons license. `n`nYou are free to distribute, modify and reupload this work however you see fit. `n`nCommercial use of the tool (selling it, renting it, making money off of it, etc) is not allowed without express permission from the author.
Gui, 2:Add, Text, w200 x10 y190, If you'd like to report an issue with the tool or provide feedback, you can do so at the Skyrim Online forums by clicking this link:
Gui, 2:Font, underline
Gui, 2:Add, Text, cBlue gOpenThread, SDT Forum Thread
Gui, 2:Font, norm
; Move buttons in GUI 1 to correct locations
GuiControl, Move, Scan, w100 h30
GuiControl, Move, Forums, x10 y435 w100 h30
GuiControl, Move, Exit, x10 y470 w100 h30
GuiControl, Move, Download appropriate drivers, x130 y400 w250 h30
GuiControl, Move, Install .Net Framework 4.5, x130 y435 w250 h30
GuiControl, Move, Download Visual Studio 2012 x86 Redistributable, x130 y470 w250 h30
GuiControl, Move, Attempt to repair installation, x390, y400, w250, h30
GuiControl, Move, Repair SKSE Installation, x390, y435, w250, h30
GuiControl, Move, Repair ScriptDragon, x390, y470, w250, h30
; Disable buttons until needed
GuiControl, Disable, Download appropriate drivers
GuiControl, Disable, Install .Net Framework 4.5
GuiControl, Disable, Download Visual Studio 2012 x86 Redistributable
GuiControl, Disable, Attempt to repair installation
GuiControl, Disable, Repair SKSE Installation
GuiControl, Disable, Repair ScriptDragon
;Create GUI
Gui, Show, h510 w650, Skyrim Online Diagnostics Tool
return

ButtonScan:
; Reset all buttons
GuiControl, Disable, Download appropriate drivers
GuiControl, Disable, Install .Net Framework 4.5
GuiControl, Disable, Download Visual Studio 2012 x86 Redistributable
GuiControl, Disable, Attempt to repair installation
GuiControl, Disable, Repair SKSE Installation
GuiControl, Disable, Repair ScriptDragon
; Clear ListView if scanning again
LV_Delete()
; Check (likely) driver version
RegRead, DriverVersion, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}_Display.Driver, DisplayVersion
if (DriverVersion = 314.22)
    {
    LV_Add("", "NVIDIA Driver Version", "Most likely compatible!")
    LV_ModifyCol()
    } else
    {
    LV_Add("", "NVIDIA Driver Version", "Most likely incompatible - please verify that you have version 314.22")
    LV_ModifyCol()
    GuiControl, Enable, Download appropriate drivers
    }
if ErrorLevel = 1
    {
    LV_Add("", "Catalyst Drivers", "You are most likely using an ATI GPU, which is right now unsupported by this tool. It's also possible you have an NVIDIA card, but the drivers are too outdated for this tool to recognize.")
    LV_ModifyCol()
    }
; Check .NET Version
RegRead, DotNetVersion, HKEY_CLASSES_ROOT, Installer\Products\0D741DA1E0EBC6D3CA11466FCD14361F, ProductName
if (DotNetVersion = "Microsoft .NET Framework 4.5") 
    {
    LV_Add("","Microsoft .NET Framework 4.5", "Installed!")
    LV_ModifyCol()
    } else
    {
    LV_Add("", "Microsoft .NET Framework 4.5", "Not Installed!")
    LV_ModifyCol()
    GuiControl, Enable, Install .Net Framework 4.5
    }
; Check Visual Redist Version
RegRead, VisualRedistVersion, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Microsoft\DevDiv\VC\Servicing\11.0\RuntimeMinimum, Install
if (VisualRedistVersion = 1)
    {
    LV_Add("", "Visual Studio 2012 x86 Redistributable", "Installed!")
    LV_ModifyCol()
    } else
    {
    LV_Add("", "Visual Studio 2012 x86 Redistributable", "Not Installed!")
    LV_ModifyCol()
    GuiControl, Enable, Download Visual Studio 2012 x86 Redistributable
    }
; Check file integrity
Regread, SkyrimPath, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\Bethesda Softworks\Skyrim, Installed Path
TotalFiles = 51
IfNotExist, %SkyrimPath%\d3d9.dll
    {
    LV_Add("", "d3d9.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\dinput8.dll
    {
    LV_Add("", "dinput8.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Game.API.dll
    {
    LV_Add("", "Game.API.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Game.Hook.dll
    {
    LV_Add("", "Game.Hook.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Game.Script.dll
    {
    LV_Add("", "Game.Script.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\horsespawner.asi
    {
    LV_Add("", "horsespawner.asi", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\horsespawner.ini
    {
    LV_Add("", "horsespawner.ini", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Lidgren.Network.dll
    {
    LV_Add("", "Lidgren.Network.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\log4net.dll
    {
    LV_Add("", "log4net.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\MonoGame.Framework.dll
    {
    LV_Add("", "MonoGame.Framwork.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\MyGUIEngine.dll
    {
    LV_Add("", "MyGUIEngine.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Oblivion.Online.dll
    {
    LV_Add("", "Oblivion.Online.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Oblivion.Script.dll
    {
    LV_Add("", "Oblivion.Script.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\OIS.dll
    {
    LV_Add("", "OIS.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\resources.xml
    {
    LV_Add("", "resources.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\ScriptDragon.dll
    {
    LV_Add("", "ScriptDragon.dll", "ScriptDragon is not installed!")
    LV_ModifyCol()
    GuiControl, Enable, Repair ScriptDragon
    TotalFiles -= 1
    }
; ScriptDragon is special case and needs an installation confirmation
IfExist, %SkyrimPath%\ScriptDragon.dll
    {
    LV_ADD("", "ScriptDragon", "Installed!")
    LV_ModifyCol()
    }
IfNotExist, %SkyrimPath%\Skyrim.Script.dll
    {
    LV_Add("", "Skyrim.Script.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\trainer.asi
    {
    LV_Add("", "trainer.asi", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\trainer.ini
    {
    LV_Add("", "trainer.ini", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\undress.asi
    {
    LV_Add("", "undress.asi", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\undress.ini
    {
    LV_Add("", "undress.ini", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\weather.asi
    {
    LV_Add("", "weather.asi", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\weather.ini
    {
    LV_Add("", "weather.ini", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\version.dll
    {
    LV_Add("", "version.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\OBSE\Plugins\Oblivion.Online.dll
    {
    LV_Add("", "Data\Online\OBSE\Plugins\Oblivon.Online.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Modules\Game.Client.dll
    {
    LV_Add("", "Modules\Game.Client.dll", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\chat.xml
    {
    LV_Add("", "chat.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\DejaVuSans.ttf
    {
    LV_Add("", "DejaVuSans.ttf", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackBlueImages.xml
    {
    LV_Add("", "MyGUI_BlackBlueImages.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackBlueSkins.png
    {
    LV_Add("", "MyGUI_BlackBlueSkins.png", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackBlueSkins.xml
    {
    LV_Add("", "MyGUI_BlackBlueSkins.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackBlueTemplates.xml
    {
    LV_Add("", "MyGUI_BlackBlueTemplates.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackBlueTheme.xml
    {
    LV_Add("", "MyGUI_BlackBlueTheme.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackOrangeImages.xml
    {
    LV_Add("", "MyGUI_BlackOrangeImages.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackOrangeSkins.png
    {
    LV_Add("", "MyGUI_BlackOrangeSkins.png", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackOrangeSkins.xml
    {
    LV_Add("", "MyGUI_BlackOrangeSkins.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackOrangeTemplates.xml
    {
    LV_Add("", "MyGUI_BlackOrangeTemplates.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlackOrangeTheme.xml
    {
    LV_Add("", "MyGUI_BlackOrangeTheme.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlueWhiteImages.xml
    {
    LV_Add("", "MyGUI_BlueWhiteImages.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlueWhiteSkins.png
    {
    LV_Add("", "MyGUI_BlueWhiteSkins.png", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlueWhiteSkins.xml
    {
    LV_Add("", "MyGUI_BlueWhiteSkins.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlueWhiteTemplates.xml
    {
    LV_Add("", "MyGUI_BlueWhiteTemplates.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_BlueWhiteTheme.xml
    {
    LV_Add("", "MyGUI_BlueWhiteTheme.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_CommonSkins.xml
    {
    LV_Add("", "MyGUI_CommonSkins.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Core.xml
    {
    LV_Add("", "MyGUI_Core.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Fonts.xml
    {
    LV_Add("", "MyGUI_Fonts.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Images.xml
    {
    LV_Add("", "MyGUI_Images.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Layers.xml
    {
    LV_Add("", "MyGUI_Layers.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Pointers.png
    {
    LV_Add("", "MyGUI_Pointers.png", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Pointers.xml
    {
    LV_Add("", "MyGUI_Pointers.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
IfNotExist, %SkyrimPath%\Data\Online\UI\MyGUI_Settings.xml
    {
    LV_Add("", "MyGUI_Settings.xml", "File missing!")
    LV_ModifyCol()
    TotalFiles -= 1
    }
; Check for SKSE
IfNotExist, %SkyrimPath%\skse_loader.exe
    {
    LV_Add("", "SKSE", "Not installed!")
    LV_ModifyCol()
    GuiControl, Enable, Repair SKSE Installation
    }
; Add installation confirmation for SKSE
IfExist, %SkyrimPath%\skse_loader.exe
    {
    LV_ADD("", "SKSE", "Installed!")
    LV_ModifyCol()
    }
; Print number of OK or broken files  
OKFiles := (51 - TotalFiles)
If (OKFiles = 1)
    {
    LV_Add("", "File Verification Completed", OKFiles " damaged or missing file found.")
    LV_ModifyCol()
    } else
    {
    LV_Add("", "File Verification Completed", OKFiles " damaged or missing files found.")
    LV_ModifyCol()
    }
If (TotalFiles < 51)
{
GuiControl, Enable, Attempt to repair installation
}
return

About:
Gui, 2:Show,, About
return

OpenThread:
Run, http://forums.skyrim-online.com/showthread.php?tid=933
return

DownloadDrivers:
Ifexist, C:\Program Files (x86)
    Run, http://www.nvidia.com/object/win8-win7-winvista-64bit-314.22-whql-driver.html
IfNotExist, C:\Program Files (x86)
    Run, http://www.nvidia.com/object/win8-win7-winvista-32bit-314.22-whql-driver.html
Msgbox, Make sure to remove the previous drivers before installing the new version. If not, problems may occur. Installing this version of the drivers should fix any renderer or 0xc0000142 errors.
return

InstallRedist:
UrlDownloadToFile, http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU3/vcredist_x86.exe, %A_Temp%\vcredist_x86.exe
RunWait, %A_Temp%\vcredist_x86.exe
FileDelete, %A_Temp%\vcredist_x86.exe
return

InstallDotnet:
UrlDownloadToFile, http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe, %A_Temp%\dotNetFx45_Full_setup.exe
RunWait, %A_Temp%\dotNetFx45_Full_setup.exe
FileDelete, %A_Temp%\dotNetFx45_Full_setup.exe
return

RepairInstallation:
UrlDownloadToFile, http://goo.gl/wstAS1, Client.zip
SmartZip("Client.zip", SkyrimPath)
Msgbox, Reparation completed.
return

InstallSKSE:
UrlDownloadToFile, http://skse.silverlock.org/download/skse_1_06_16_installer.exe, %A_Temp%\skse_1_06_16_installer.exe
RunWait, %A_Temp%\skse_1_06_16_installer.exe
FileDelete, %A_Temp%\skse_1_06_16_installer.exe
return

RepairScriptDragon:
UrlDownloadToFile, http://goo.gl/NBZaoZ, ScriptDragon.zip
SmartZip("ScriptDragon.zip", SkyrimPath)
Msgbox, Reparation completed.
return

OpenForums:
Run, http://forums.skyrim-online.com/forumdisplay.php?fid=9
return

ExitTool:
FileDelete, ScriptDragon.zip
FileDelete, Client.zip
ExitApp

GuiClose:
FileDelete, ScriptDragon.zip
FileDelete, Client.zip
ExitApp