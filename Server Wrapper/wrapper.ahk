#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\server\ ; Needed for Game.Server to read from the proper configuration files
#Include lib\uuid.ahk
#Include lib\tf.ahk
#Include lib\WatchDirectory.ahk

; Default values for use later
DefaultGame = Skyrim
DefaultName = Skyrim Online Server
DefaultAddress = 127.0.0.1
DefaultPort = 14242
DefaultIsPrivate = 0
DefaultLanguage = |English||Polish
DefaultPassword =
DefaultGUID = 

; Get startup values
IniRead, IniSelectedGame, %A_ScriptDir%\server\GameServer.ini, General, Game
If (IniSelectedGame = "Skyrim"){
    IsSkyrim = 1
    IsOblivion = 0
    }
    else if (IniSelectedGame = "Oblivion"){
    IsOblivion = 1
    IsSkyrim = 0
    }
IniRead, IniServerName, %A_ScriptDir%\server\GameServer.ini, General, Name
IniRead, IniAddress, %A_ScriptDir%\server\GameServer.ini, General, Address
IniRead, IniPort, %A_ScriptDir%\server\GameServer.ini, General, Port
IniRead, IniIsPrivate, %A_ScriptDir%\server\GameServer.ini, General, Online
If (IniIsPrivate = "true") {
    SetPrivate = 0
    } else if (IniIsPrivate = "false") {
    SetPrivate = 1
    }
IniRead, IniLanguage, %A_ScriptDir%\server\GameServer.ini, General,Language
If (IniLanguage = "English") {
    SelectedLanguage = 1
    } else if (IniLanguage = "Polish") {
    SelectedLanguage = 2
    }
IniRead, IniPassword, %A_ScriptDir%\server\GameServer.ini, General, Password
IniRead, IniGUID, %A_ScriptDir%\server\GameServer.ini, Master, GUID
; Create tabs
Gui, Add, Tab2, gSaveOptions w630 h385, Server|Configuration
; Server tab
Gui, Tab, Server
Gui, Add, ListView, x10 y25 r20 w630, Log
Gui, Add, Button, gStartServer, Start Server
Gui, Add, Button, gStopServer, Stop Server
; Move server tab buttons
GuiControl, Move, Start Server, w100 h30
GuiControl, Move, Stop Server, x115 y399 w100 h30
; Config tab
Gui, Tab, Configuration
Gui, Add, Text,, Game Type:
Gui, Add, Radio, Checked%IsSkyrim% vSetGameTypeSkyrim, Skyrim
Gui, Add, Radio, Checked%IsOblivion% vSetGameTypeOblivion, Oblivion
Gui, Add, Text,, Server Name:
Gui, Add, Edit, vServerName Limit40 gSetServerName, %IniServerName%
Gui, Add, Text,, Server Language: 
Gui, Add, DropDownList, vServerLanguage Choose%SelectedLanguage% AltSubmit, English|Polish
Gui, Add, Text,, Private Server
Gui, Add, Checkbox, Checked%SetPrivate% vIsPrivate gEnablePassword, Set server as private
Gui, Add, Text,, Password:
Gui, Add, Edit, vServerPassword Limit40 gSetServerPassword, %IniPassword%
Gui, Add, Text,, Address:
Gui, Add, Edit, vServerAddress gSetServerAddress, %IniAddress%
Gui, Add, Text,, Port:
Gui, Add, Edit, vServerPort gSetServerPort Number, %IniPort%
Gui, Add, Text,, GUID:
Gui, Add, Edit, vServerGUID gSetServerGUID, %IniGUID%
Gui, Add, Button, gGenerateGUID, Generate GUID
Gui, Add, Button, gSetDefaults, Reset Settings
; Move config tab controls
Gui, Submit, NoHide
GuiControl, Move, ServerName, w200
GuiControl, Move, Private Server, x275 y35
GuiControl, Move, IsPrivate, x275 y55 w200
GuiControl, Move, Password:, x275 y75
GuiControl, Move, ServerPassword, x275 y95 w200
    ; Check if we're already private and enable or disable password
if (SetPrivate = 0) {
    GuiControl, Disable, ServerPassword
    }

GuiControl, Move, ServerAddress, w200
GuiControl, Move, ServerPort, w200

GuiControl, Move, GUID:, x275 y145
GuiControl, Move, ServerGUID, x275 y175 w300
GuiControl, Move, Generate GUID, x275 y200 h25 w100

GuiControl, Move, Reset Settings, x530 y355 h25 w100

Gui, Show, h450
return

StartServer:
Run, %A_ScriptDir%\server\Game.Server.exe
Sleep, 1500
IsRunning = 1
; This section wraps the log output to the listview in the main tab
; Needs tons of improvement - doubtful that it even works
Loop, read, %A_ScriptDir%\server\Game.Server.log
{
    Loop, parse, A_LoopReadLine, `n, `r 
    {
        LV_Add("", A_LoopField)
        LV_ModifyCol()
    }
}
return

StopServer:
; Kills game process
Process, Close, Game.Server.exe
return

; Handling subroutines
EnablePassword:
Gui, Submit, NoHide
if (IsPrivate = 0) {
    GuiControl, Disable, ServerPassword
    } else if (IsPrivate = 1) {
    GuiControl, Enable, ServerPassword
    }
return

GenerateGUID:
; Uses modified UUID library to generate and paste compatible GUID
ServerGUID = % uuid(false)
GuiControl,, ServerGUID, %ServerGUID%
Gui, Submit, NoHide
return

SetDefaults:
; Wipes all settings and restores them to defaults defined in the beginning of the script
MsgBox, 20, Wiping Settings ,WARNING - This will wipe all of your settings and restore the default configuration. Continue?
IfMsgBox, No
    return
IniWrite, %DefaultGame%, %A_ScriptDir%\server\GameServer.ini, General, Game
IniWrite, %DefaultName%, %A_ScriptDir%\server\GameServer.ini, General, Name
IniWrite, %DefaultPassword%, %A_ScriptDir%\server\GameServer.ini, General, Password
IniWrite, %DefaultAddress%, %A_ScriptDir%\server\GameServer.ini, General, Address
IniWrite, %DefaultPort%, %A_ScriptDir%\server\GameServer.ini, General, Port
IniWrite, %DefaultGUID%, %A_ScriptDir%\server\GameServer.ini, Master, GUID
GuiControl,, SetGameTypeSkyrim, 1
GuiControl,, ServerName, %DefaultName%
GuiControl,, ServerLanguage, %DefaultLanguage%
GuiControl,, IsPrivate, 0
GuiControl,, ServerPassword, %DefaultPassword%
GuiControl,, ServerAddress, %DefaultAddress%
GuiControl,, ServerPort, %DefaultPort%
GuiControl,, ServerGUID, %DefaultGUID%
GuiControl, Disable, ServerPassword
Gui, Submit, NoHide

; Subroutines for saving
SaveOptions:
Gui, Submit, NoHide
if (SetGameTypeSkyrim = 1) {
    IniWrite, Skyrim, %A_ScriptDir%\server\GameServer.ini, General, Game 
    } else if (SetGameTypeOblivion = 1) {
    IniWrite, Oblivion, %A_ScriptDir%\server\GameServer.ini, General, Game 
    }
if (ServerLanguage = 1) {
    IniWrite, English, %A_ScriptDir%\server\GameServer.ini, General, Language
    } else if (ServerLanguage = 2) {
    IniWrite, Polish, %A_ScriptDir%\server\GameServer.ini, General, Language
    }
if (IsPrivate = 0) {
    IniWrite, true, %A_ScriptDir%\server\GameServer.ini, General, Online
    } else if (IsPrivate = 1) {
    IniWrite, false, %A_ScriptDir%\server\GameServer.ini, General, Online
    }
return

SetServerName:
Gui, Submit, NoHide
IniWrite, %ServerName%, %A_ScriptDir%\server\GameServer.ini, General, Name 
return

SetServerPassword:
Gui, Submit, NoHide
IniWrite, %ServerPassword%, %A_ScriptDir%\server\GameServer.ini, General, Password
return

SetServerAddress:
IniWrite, %ServerAddress%, %A_ScriptDir%\server\GameServer.ini, General, Address
return

SetServerPort:
IniWrite, %ServerPort%, %A_ScriptDir%\server\GameServer.ini, General, Port
return

SetServerGUID:
IniWrite, %ServerGUID%, %A_ScriptDir%\server\GameServer.ini, Master, GUID
return


GuiClose:
if (IsRunning = 1) {
    MsgBox, 20, Warning ,Exiting the control center will terminate any running servers without saving. Continue?
    IfMsgBox, No
        return
    }
Process, Close, Game.Server.exe
Process, WaitClose, Game.Server.exe
ExitApp
