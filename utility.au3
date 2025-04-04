Func showTooltip($str, $x, $y)
	ToolTip($str, $x, $y, $scriptName & " v" & $scriptVersion)
EndFunc

Func setTooltip($str) 
	;ToolTip ( "text" [, x [, y [, "title" [, icon = 0 [, options]]]]] )

	ToolTip ($str, 300, 0)
EndFunc

Func mouseTooltip($str)
	Local $pos = MouseGetPos()
	ToolTip($str, $pos[0], $pos[1])
EndFunc

Func removeTooltip()
	ToolTip("")
EndFunc

Func ranNum($min, $max)
	If ($min > $max) Then
		Return Random ($max, $min, 1)
	Else
		Return Random ($min, $max, 1)
	EndIf
EndFunc

Func ranSleep($min, $max)
	sleep(ranNum($min, $max))
EndFunc

Func exitScript()
	
	;saveSettings()
	;Sleep(2000)
	Exit
EndFunc

Func moveMouseArea($left, $right, $top, $bottom)
	MouseMove($left, $top, 20) ;left top
	MouseMove($right, $top, 20) ;right top
	MouseMove($right, $bottom, 20) ;right bottom
	MouseMove($left, $bottom, 20) ;left bottom
	MouseMove($left, $top, 20) ;left top
EndFunc





Func setWindowTitle()
	If GUICtrlRead($hideTitle) = $GUI_CHECKED Then
		WinSetTitle ($mainGui, "", "Untitled - Notepad")
	Else
		WinSetTitle ($mainGui, "", $windowTitle)
	EndIf
	saveSettings()
EndFunc


Func setWindowIcon()
	If GUICtrlRead($hideIcon) = $GUI_CHECKED Then
		GUISetIcon ("files/notepad.ico", Default, $mainGui )
	Else
		GUISetIcon ("files/icon.ico", Default, $mainGui )
	EndIf


	saveSettings()
EndFunc



Func setMouseSpeed()
	;Global $mouseSpeed = ranNum( Number(GUICtrlRead($mouseSpeedMin)), Number(GUICtrlRead($mouseSpeedMax)) )
	Global $mouseSpeed = 0
EndFunc

Func _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor = 0x00ff0d)
    Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
    Local $tRect = DllStructCreate($tagRECT)
    DllStructSetData($tRect, 1, $start_x)
    DllStructSetData($tRect, 2, $start_y)
    DllStructSetData($tRect, 3, $iWidth)
    DllStructSetData($tRect, 4, $iHeight)
    Local $hBrush = _WinAPI_CreateSolidBrush($iColor)

    _WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)

    ; clear resources
    _WinAPI_DeleteObject($hBrush)
    _WinAPI_ReleaseDC(0, $hDC)
EndFunc   ;==>_WinAPI_DrawRect

Func flashRect($array)
	;left, right, top, bottom
	For $i = 0 To 5 Step +1
		_WinAPI_DrawRect($array[0], $array[1] , $array[2], $array[3], 0x00ff0d)
	Next
EndFunc

Func toggleInput()

	Local $buttonTextOn = "[ON]" ;[ON]
	Local $buttonTextOff = "[OFF]" ;[OFF]

	Local $statusTextOn = "  ■ Macro engine ready..." 
	Local $statusTextOff = "  ■ Macro engine off" 
	;$scriptStatusLabel

	Local $bgColorOn = 0x32a852
	Local $bgColorOff = 0x123b1d
	Local $textColorOn = $COLOR_WHITE
	Local $textColorOff = $COLOR_GRAY


	If $allowInput Then
		$allowInput = false
		;GUICtrlSetData($toggleInputButton, "[OFF]")
		;GUICtrlSetBkColor($toggleInputButton, $bgColorOff)
		GuiFlatButton_SetData($toggleInputButton, $buttonTextOff)
		;GuiFlatButton_SetBkColor($toggleInputButton, $bgColorOff)
		;GuiFlatButton_SetColor($toggleInputButton, $textColorOff)

		GUICtrlSetData($scriptStatusLabel, $statusTextOff)
		GUICtrlSetColor($scriptStatusLabel, $COLOR_RED)

		clearHotkeys()
	Else
		$allowInput = true
		;GUICtrlSetData($toggleInputButton, "[ON]")
		;GUICtrlSetBkColor($toggleInputButton, $bgColorOn)
		;GUICtrlSetColor($toggleInputButton, $textColorOn)
		GuiFlatButton_SetData($toggleInputButton, $buttonTextOn)
		;GuiFlatButton_SetBkColor($toggleInputButton, $bgColorOn)
		;GuiFlatButton_SetColor($toggleInputButton, $textColorOn)
		GUICtrlSetData($scriptStatusLabel, $statusTextOn)
		GUICtrlSetColor($scriptStatusLabel, $COLOR_LIME)
		setHotkeys()
	EndIf
	saveSettings()

EndFunc



Func stopHere()
	MsgBox(0, 'Stop here', 'stopHere(), going to idle()')
	idle()
EndFunc


;fill macroHotkey dropdown menus with options
Func fillGuiHotkeyMenus()
	For $i = 0 To $macroAmount-1 Step +1	
		;$elems[$i] = Eval( "buffHotkey" & String($i+1) )
		Local $elem = Eval( "macroHotkey" & String($i+1) )
		;MsgBox(0, 'elem', $elem)

		For $j = 0 To Ubound($startHotkeys)-1 Step +1		
			GUICtrlSetData($elem, $startHotkeys[$j])
		Next	
	Next
EndFunc


Func coordMode($str)
	;Opt("GUICoordMode", 1) ;0 relative, 1 absolute, 2 cell position
	If $str == 'rel' Or $str == 'relative' Then
		Opt("GUICoordMode", 0) 
	ElseIf $str == 'abs' Or $str == 'absolute' Then
		Opt("GUICoordMode", 1) 
	ElseIf $str == 'cel' Or $str == 'cell' Then
		Opt("GUICoordMode", 2) 
	EndIf
EndFunc




Func showWindowRenameFormatHelp()
	$File1 = 'files/client_window_renaming_help.txt'

	; Standard AutoIt message box
	;MsgBox(0, 'FlyffHelper: Client window renaming format help', FileRead($File1, FileGetSize($File1)))

	;_ExtMsgBox ($vIcon, $vButton, $sTitle, $sText, [$vTimeout, [$hWin, [$iVPos, [$bMain = True]]]])

	_ExtMsgBox(0, 'OK', 'FlyffHelper: Client window renaming format help', FileRead($File1, FileGetSize($File1)))

	;_ExtMsgBoxSet($iStyle, $iJust, [$iBkCol, [$iCol, [$sFont_Size, [$iFont_Name, [$iWidth, [$iWidth_Abs, [$sFocus_Char, [$sTitlebar_Icon]]]]]]]])
EndFunc

Func showHelp()
	$File1 = 'help.txt'
	_ExtMsgBox(0, 'OK', 'IdleScape AutoAfk: help.txt', FileRead($File1, FileGetSize($File1)))
	;_ExtMsgBoxSet($iStyle, $iJust, [$iBkCol, [$iCol, [$sFont_Size, [$iFont_Name, [$iWidth, [$iWidth_Abs, [$sFocus_Char, [$sTitlebar_Icon]]]]]]]])
EndFunc


Func formatMs($ms, $days)
	Local $s = $ms/1000
	Local $m = $s/60
	Local $h = $m/60
	Local $d = $h/24
	
	$s = Mod($s,60)
	$m = Mod($m,60)
	$h = Mod($h,24)
	$d = Floor($d)

	Local $str = StringFormat("%02d:%02d:%02d", $h, $m, $s)

	if ($days) Then
		$str = StringFormat("%s days, %02d:%02d:%02d", $d, $h, $m, $s)
	EndIf
	
	return $str
EndFunc