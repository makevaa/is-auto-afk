#AutoIt3Wrapper_Icon=files\icon.ico
#AutoIt3Wrapper_Outfile=IS-AutoAfk.exe
#AutoIt3Wrapper_Res_HiDpi=PM ;can be Y, N, or PM (per-monitor), PM seems to be the best choice
#AutoIt3Wrapper_Run_AU3Check=n
;#RequireAdmin

#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#Include <Array.au3>
#include <AutoItConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <FontConstants.au3>
#include <StaticConstants.au3>
#include <ScreenCapture.au3>
#include <Misc.au3>
#include <GDIPlus.au3>



Global $scriptName = "Idlescape AutoAfk"
Global $scriptVersion = "1.0.2 styx"
Global $windowTitle = $scriptName & " v" & $scriptVersion


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
#include "save.au3"


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

			Case $hideTitle
				setWindowTitle()

			Case $hideIcon
				setWindowIcon()

			Case $helpButton
				showHelp()
		EndSwitch
	
		;drawGraphics()
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
	Sleep(500)
	activateChrome()

	;Open new tab (CTRL + T)
	Sleep(500)
	Send("^t")

	;Select Chrome address bar (ALT + D)
	Sleep(500)
	Send("!d")

	;Paste "https://www.play.idlescape.com/characters" to address bar
	Sleep(500)
	Send("https://www.play.idlescape.com/characters{ENTER}")
	

	;Press Enter to open address
	Sleep(500)
	;Send("{ENTER}")

	;Wait a moment
	Sleep(1000)

	;CTRL + F5 (hard-reload page to update client)
	Sleep(500)
	Send("^{F5}")
	Sleep(10000)

	; Check for login screen
	Send("!d") ; Select address bar url
	Sleep(500)
	Send("^c") ; Copy url to clipboard
	Sleep(500)

	if ClipGet () == "https://www.idlescape.com/login" Then
		; Send tabs to select login button
		For $i = 0 To 10 Step +1
			Send("{TAB}")
			Sleep(500)
		Next
		; Click login button
		Send("{ENTER}")
		Sleep(500)
	EndIf

	;Click character image (left)
	moveMouseToCharacter($left)
	Sleep(1000)
	MouseClick($MOUSE_CLICK_LEFT)

	;Wait a moment
	Sleep(10000)

	;Close tab (CTRL + W)
	Sleep(500)
	Send("^w")
EndFunc


Func refreshCharacters()
	refreshCharacter(true) ; Click left character (main)
	refreshCharacter(false) ;Click right charcater (ironman)
EndFunc


Func panicButtonPressed($dll)
	If _IsPressed($idleHotkeyCode, $dll) Then 
		DllClose($dll)
		return true
	Else
		return false
	EndIf
EndFunc


Func wait($min, $max, $dll)
	Local $timeout = ranNum($min, $max)
	Local $timer = TimerInit()

	While True
		If timerDiff($timer) >  $timeout Then ExitLoop
		If panicButtonPressed($dll) Then 
			idle()
		EndIf
		Sleep(20)
	WEnd
EndFunc


Func startAfk() 
	Local $startTime = _NowTime()
	Local $totalTimer = TimerInit()
	Local $refreshes = 0

	Local $intervalMin = 1000*60*60*11 ;ms, 11 hours
	Local $intervalMax = 1000*60*60*12 ;ms, 12 hours

	; Refresh characters on start
	If (true) Then
		refreshCharacters()
		$refreshes += 1
	EndIf

	Local $interval = ranNum($intervalMin, $intervalMax)
	Local $intervalTimer = TimerInit()

	$timeRan = formatMs(TimerDiff($totalTimer))
	$timeToRefresh = formatMs( $interval - TimerDiff($totalTimer) )

	While True
		If ( timerDiff($intervalTimer) >  $interval) Then
			refreshCharacters()
			$intervalTimer = TimerInit()
			$interval = ranNum($intervalMin, $intervalMax)
			$refreshes += 1
		EndIf

		$timeRan = formatMs(TimerDiff($totalTimer))
		$timeToRefresh = formatMs( $interval - TimerDiff($totalTimer) )

		setToolTip("IdlescapeAutoAfk ✔ | Refreshes: <" & $refreshes & "> | Time ran: " & $timeRan & " | Next refresh: " & $timeToRefresh)
		Sleep(1000)
	WEnd
EndFunc


loadSettings($configFile)
GUISetState(@SW_SHOW, $mainGui)

setWindowTitle()
setWindowIcon()

HotkeySet ("{F9}", startAfk)
HotkeySet ("{" & $idleHotkey & "}", idle)
HotkeySet ("{F11}", exitScript)

setMouseSpeed()
idle()
