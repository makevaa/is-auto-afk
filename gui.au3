;gui.au3

Global $COLOR_GREY = $COLOR_GRAY

Global $guiSize[2] = [250, 270] ;x, y
Global $guiColumnX = 40

Global $guiBgColor = "0x" & "192534" ; 252526 1f272e 192534
Global $guiDefaultTextColor = 0xffffff

Global $guiButtonBgColor = "0x" & "213145" ; 3c3c3c
Global $guiButtonBorderColor = "0x" & "808080" ;green  00ff00
Global $guiTextFieldBgColor = "0x" & "19191a" 


;set default colors for buttons created with GuiFlatButton UDF
;sets of 3 colors for 4 states: background/text/border for normal, focus, hover, selected
Local $aColorsEx = [ _
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor, _ ;normal -1 lime: 0x00ff00  0xFFFFFF
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor, _ ;focus, background text border
					0x111922, 0xFFFFFF, $guiButtonBorderColor, _ ;hover
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor _ ;selected
					]
GuiFlatButton_SetDefaultColorsEx($aColorsEx)


; Draw filled box
Func createGuiBox($x, $y, $w, $h, $color)
	Local $box = GUICtrlCreateLabel("", $x, $y, $w, $h, $WS_DISABLED)
	GUICtrlSetBkColor($box, $color)
EndFunc

; Create flat drop-shadow for gui elem
Func createShadow($guiCtrl, $offset=3, $color=0x111922)
	Local $elemPos = ControlGetPos ($mainGui, WinGetTitle($mainGui), $guiCtrl) ;x, y, w, h
	Local $x = $elemPos[0]
	Local $y = $elemPos[1]
	Local $w = $elemPos[2]
	Local $h = $elemPos[3]

	;createGuiBox($x, $y, $w, $h, $color)

	;Right side shadow
	createGuiBox($x+$w, $y+$offset, $offset, $h, $color)
	;bottom side shadow
	createGuiBox($x+$offset, $y+$h, $w, $offset, $color)
EndFunc


Global $mainGui = GUICreate($windowTitle, $guiSize[0], $guiSize[1])
GUISetFont(10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas") ;
GUISetBkColor($guiBgColor, $mainGui)
GUICtrlSetDefColor($guiDefaultTextColor) ;0xff981f 0x00d2ac 0x00d0ff 0xffff40 0x00ff00


coordMode('abs')
Global $guiScriptNameLabel = GUICtrlCreateLabel($scriptName & " v" & $scriptVersion, $guiColumnX, 20)
GUICtrlSetColor($guiScriptNameLabel, 0x00ffff)
GUICtrlSetBkColor($guiScriptNameLabel, $guiBgColor)
;GUICtrlSetColor(-1, $COLOR_BLUE)

Global $descLabel = GUICtrlCreateLabel("IdleScape timer refresher", $guiColumnX, 40, 150, 50)
GUICtrlSetColor($descLabel, 0x0066ff)

coordMode('abs')
Global $hotkeysLabel = GUICtrlCreateLabel("• F9  start afk" & @CRLF & "• F10 idle/end afk" & @CRLF & "• F11 exit script", $guiColumnX, 100, 200, 60)
GUICtrlSetColor(-1, $COLOR_GRAY)


coordMode('abs')
Global $helpButton = GuiFlatButton_Create("Help", $guiColumnX, 190, 170, 50)
GUICtrlSetFont(-1, 10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas")
createShadow($helpButton, 3)
GUICtrlSetCursor ($helpButton, $MCID_HAND)


GUISetIcon("files/icon.ico") 
GUISetState()
