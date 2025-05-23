#AutoIt3Wrapper_Icon=files\icon.ico
#AutoIt3Wrapper_Outfile=IS-AutoAfk.exe
#AutoIt3Wrapper_Res_HiDpi=PM ;can be Y, N, or PM (per-monitor), PM seems to be the best choice
#AutoIt3Wrapper_Run_AU3Check=n
;#RequireAdmin

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>

#include <ButtonConstants.au3>
;#include <ComboConstants.au3>
;#Include <Array.au3>
#include <AutoItConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>
;#include <File.au3>
#include <FontConstants.au3>
#include <StaticConstants.au3>
;#include <ScreenCapture.au3>
#include <Misc.au3>
#include <GDIPlus.au3>



Global $scriptName = "IS-AutoAfk"
Global $scriptVersion = "1.0.32"
Global $windowTitle = $scriptName


Global $configFile = @ScriptDir & "\files\config.ini"

Global $idleHotkey = "F10"
Global $idleHotkeyCode = "79" ;77 F8 key, 79 f10, 7A F11



#include "utility.au3"
#include "lib/GuiFlatButton.au3"

#include "lib/GUIComboBox/GUICtrlComboSetColors.au3"
#include "lib/GUIComboBox/GUIComboBoxColor.au3"
#include "lib/GUIComboBox/GUIComboBoxFont.au3"
#include "lib/ExtMsgBox/ExtMsgBox.au3"

#include "gui.au3"



; Initilaize ExtMsgBox styles
;_ExtMsgBoxSet($iStyle, $iJust, [$iBkCol, [$iCol, [$sFont_Size, [$iFont_Name, [$iWidth, [$iWidth_Abs, [$sFocus_Char, [$sTitlebar_Icon]]]]]]]])
_ExtMsgBoxSet(2, 0, "0x"&"252526", 0xffffff, Default, "Consolas", 500, 600, Default, 'files/icon.ico')

Global $idling = false
Global $allowInput = true


Func idle()
	$idling = true
	Send("{CTRLUP}")
	Send("{ALTUP}")
	Send("{SHIFTUP}")
	removeTooltip()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				exitScript()

			Case $helpButton
				showHelp()
		EndSwitch
	
		sleep(50)
	WEnd
EndFunc


Func activateChrome()
	Local $browserTitle = "New Tab - Google Chrome"
	If WinExists($browserTitle) Then
		WinActivate($browserTitle)
	EndIf
EndFunc


Func moveMouseToCharacter($left)
	Local $browserPos = WinGetPos("[Active]") ;x, y, w, h

	Local $x = $browserPos[2] / 2 - 100
	Local $y = $browserPos[3] - 80

	If ($left <> True) Then
		$x = $browserPos[2] / 2 + 100
	EndIf

	MouseMove($x, $y, $mouseSpeed) 
	Sleep(500)
	
EndFunc


Func refreshCharacter($left) 
#cs 
	Start script with chrome active with an empty tab

	Activate Chrome window
	Open new tab (CTRL + T)
	Select Chrome address bar (ALT + D)
	Paste "https://www.play.idlescape.com/characters", 
	Press Enter to open address
	Wait a moment
	CTRL + F5 (hard-reload page to update client)
	Check for login screen
		Select login button and enter if in login screen
	Click character image (main/iron, left/right)
	Wait a moment
	Close tab (CTRL + W)
	(repeat for the other character)
#ce

	Send("{CTRLUP}")
	Send("{ALTUP}")
	Send("{SHIFTUP}")

	;Start script with chrome active with an empty tab

	;Activate Chrome window
	Sleep(1000)
	activateChrome()

	;Open new tab (CTRL + T)
	Sleep(1000)
	Send("^t")

	;Select Chrome address bar (ALT + D)
	Sleep(1000)
	Send("!d")

	;Paste "https://www.play.idlescape.com/characters" to address bar
	Sleep(1000)
	Send("https://www.play.idlescape.com/characters{ENTER}")

	;Wait a moment
	Sleep(10000)

	;CTRL + F5 (hard-reload page to update client)
	Sleep(1000)
	Send("^{F5}")
	Sleep(30000)

	; Check for login screen
	Send("!d") ; Select address bar url
	Sleep(1000)
	Send("^c") ; Copy url to clipboard
	Sleep(1000)

	if ClipGet () == "https://www.idlescape.com/login" Then
		; Send tabs to select login button
		For $i = 0 To 10 Step +1
			Send("{TAB}")
			Sleep(1000)
		Next
		; Click login button
		Send("{ENTER}")
		Sleep(1000)
	EndIf

	;Click character image (left)
	moveMouseToCharacter($left)
	Sleep(10000)
	MouseClick($MOUSE_CLICK_LEFT)

	;Wait a moment
	Sleep(30000)

	;Close tab (CTRL + W)
	Sleep(1000)
	Send("^w")
EndFunc


Func refreshCharacters()
	refreshCharacter(true) ; Click left character (main)
	refreshCharacter(false) ;Click right charcater (ironman)
EndFunc




Func startAfk() 
	setToolTip("IdlescapeAutoAfk ✔ | Starting...")
	Local $startTime = _NowTime()
	Local $totalTimer = TimerInit()
	Local $refreshes = 0

	Local $intervalMin = 1000*60*60*11 ;ms, 11 h
	Local $intervalMax = 1000*60*60*11.5 ;max 11.5 h

	;$intervalMin = 1000*60*1 ;debug
	;$intervalMax = 1000*60*1.5 ;debug

	; Refresh characters on start
	If (true) Then
		setToolTip("IdlescapeAutoAfk ✔ | Refreshing on start...")
		refreshCharacters()
		$refreshes += 1
	EndIf

	Local $interval = ranNum($intervalMin, $intervalMax)
	Local $intervalTimer = TimerInit()

	$timeRan = formatMs(TimerDiff($totalTimer), true)
	$timeToRefresh = formatMs( $interval - TimerDiff($totalTimer), false )

	While True
		If ( timerDiff($intervalTimer) > $interval) Then
			setToolTip("IdlescapeAutoAfk ✔ | Time ran: " & $timeRan & " | Refreshing...")
			refreshCharacters()
			$intervalTimer = TimerInit()
			$interval = ranNum($intervalMin, $intervalMax)
			$refreshes += 1
		EndIf

		$timeRan = formatMs(TimerDiff($totalTimer), true)
		$timeToRefresh = formatMs($interval - TimerDiff($intervalTimer), false)

		setToolTip("IdlescapeAutoAfk ✔ | Time ran: " & $timeRan & " | Next refresh: " & $timeToRefresh & " | Refreshes: <" & $refreshes & ">")
		Sleep(10000)
	WEnd
EndFunc


GUISetState(@SW_SHOW, $mainGui)



HotkeySet ("{F9}", startAfk)
HotkeySet ("{" & $idleHotkey & "}", idle)
HotkeySet ("{F11}", exitScript)

setMouseSpeed()
idle()
