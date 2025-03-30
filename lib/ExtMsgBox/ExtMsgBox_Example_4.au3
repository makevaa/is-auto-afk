#include <GUIConstantsEx.au3>

#include "ExtMsgBox.au3"

Global $aAutoItFolder = StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", Default, -1))

$hTest_GUI = GUICreate("EMB Test", 200, 120)
$cButton1 = GUICtrlCreateButton("Test 1", 20, 20, 60, 30)
$cButton2 = GUICtrlCreateButton("Test 2", 120, 20, 60, 30)
$cButton3 = GUICtrlCreateButton("Test 3", 20, 70, 60, 30)
$cButton4 = GUICtrlCreateButton("Test 4", 120, 70, 60, 30)

GUISetState(@SW_SHOW, $hTest_GUI)

While 1

	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cButton1
			; Default BLUE Autoit titlebar icon
			_ExtMsgBoxSet(Default)
			_ExtMsgBox(0, "OK", "Test 1", "Basic EMB" & @CRLF & @CRLF & "Default Blue AutoIt titlebar icon" , 0, $hTest_GUI)
			_ExtMsgBoxSet(Default)
		Case $cButton2
			; NO titlebar icon
			_ExtMsgBoxSet(32)
			_ExtMsgBox(0, "OK", "Test 2", "No titlebar icon" , 0, $hTest_GUI)
			_ExtMsgBoxSet(Default)
		Case $cButton3
			; Global YELLOW AutoIt titlebar icon
			_ExtMsgBoxSet(0, -1, -1, -1, -1, -1, -1, -1, -1, $aAutoItFolder & "Icons\MyAutoIt3_Yellow.ico")
			_ExtMsgBox(0, "OK", "Test 3", "Global Yellow AutoIt titlebar icon" , 0, $hTest_GUI)
			_ExtMsgBoxSet(Default)
		Case $cButton4
			; Override global setting with RED AutoIt titlebar icon
			_ExtMsgBoxSet(0, -1, -1, -1, -1, -1, -1, -1, -1, $aAutoItFolder & "Icons\MyAutoIt3_Yellow.ico")
			_ExtMsgBox(0 & ";" & $aAutoItFolder & "Icons\MyAutoIt3_Red.ico", "OK", "Test 4", "Override Red AutoIt titlebar icon" , 0, $hTest_GUI)
			_ExtMsgBoxSet(Default)
	EndSwitch

WEnd