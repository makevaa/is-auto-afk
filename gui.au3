

;DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
Global $COLOR_GREY = $COLOR_GRAY

Global $guiOffset = 3
Global $settingsColumnX = 50 ;column in gui for client settings etc.
;Global $guiSize[2] = [500, 300] ;x, y
Global $guiSize[2] = [400, 300] ;x, y

Global $guiBgColor = "0x" & "192534" ; 252526 1f272e 192534
Global $guiDefaultTextColor = 0xffffff

Global $guiButtonBgColor = "0x" & "213145" ; 3c3c3c
Global $guiButtonBorderColor = "0x" & "808080" ;green  00ff00
Global $guiTextFieldBgColor = "0x" & "19191a" 


;						x, y, w, h, lineW, color, label
Global $macroRect[7] = [40, 40, 525, 740, 2, "0x"&"404040", "Macros"]
Global $clientRect[7] = [$settingsColumnX-30, 40, 350, 330, 2, "0x"&"404040", "Client settings"]

;set default colors for buttons created with GuiFlatButton UDF
;sets of 3 colors for 4 states: background/text/border for normal, focus, hover, selected
Local $aColorsEx = [ _
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor, _ ;normal -1 lime: 0x00ff00  0xFFFFFF
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor, _ ;focus, background text border
					0x111922, 0xFFFFFF, $guiButtonBorderColor, _ ;hover
					$guiButtonBgColor, 0xFFFFFF, $guiButtonBorderColor _ ;selected
					]
GuiFlatButton_SetDefaultColorsEx($aColorsEx)


; Draw a rectangle using empty gui labels with background color
Func createGuiRect($x, $y, $w, $h, $lineW, $color, $label = "")
	;Local $x=20, $y=23, $w=525, $h=450, $lineW=2, $color="0x"&"404040" 
	Local $top = GUICtrlCreateLabel("", $x, $y, $w, $lineW)
	Local $bottom = GUICtrlCreateLabel("", $x, $y+$h, $w, $lineW) 
	Local $left = GUICtrlCreateLabel("", $x, $y, $lineW, $h) 
	Local $right = GUICtrlCreateLabel("", $x+$w-$lineW, $y, $lineW, $h) 
	GUICtrlSetBkColor($top, $color)
	GUICtrlSetBkColor($bottom, $color)
	GUICtrlSetBkColor($left, $color)
	GUICtrlSetBkColor($right, $color)
EndFunc

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
;Global $mainGui = GUICreate($windowTitle, $guiSize[0], $guiSize[1], -1, -1, -1, BitOR($WS_SYSMENU, $SS_CENTERIMAGE) )
GUISetFont(10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas") ;
GUISetBkColor($guiBgColor, $mainGui)
GUICtrlSetDefColor($guiDefaultTextColor) ;0xff981f 0x00d2ac 0x00d0ff 0xffff40 0x00ff00


coordMode('abs')
Global $guiScriptNameLabel = GUICtrlCreateLabel($scriptName &  @CRLF & "v" & $scriptVersion, 50, 20)
GUICtrlSetColor($guiScriptNameLabel, 0x00ffff)
GUICtrlSetBkColor($guiScriptNameLabel, $guiBgColor)
;GUICtrlSetColor(-1, $COLOR_BLUE)

coordMode('rel')
Global $hideTitle = GUICtrlCreateCheckbox(" ", 200, -5, 20, default)
Global $hideIcon = GUICtrlCreateCheckbox(" ", 0, 20, 20, default)
Global $hideTitleLabel = GUICtrlCreateLabel("Hide title", 20, -20+$guiOffset, 90, default)
Global $hideIconLabel = GUICtrlCreateLabel("Hide icon", 0, 20, 90, default)

GUICtrlSetBkColor($hideTitle, $guiBgColor)
GUICtrlSetBkColor($hideIcon, $guiBgColor)
;GUICtrlSetColor($hideTitleLabel, $guiDefaultTextColor)
GUICtrlSetColor($hideIconLabel, $guiDefaultTextColor)

coordMode('abs')
Global $hotkeysLabel = GUICtrlCreateLabel("• F9 start afk" & @CRLF & "• F10 idle/end afk" & @CRLF & "• F11 exit script", 50, 80, 200, 60)
GUICtrlSetColor(-1, $COLOR_GRAY)


coordMode('abs')
Global $helpButton = GuiFlatButton_Create("Help",  100, 180, 100, 50)
GUICtrlSetFont(-1, 10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas")
createShadow($helpButton, 3)
GUICtrlSetCursor ($helpButton, $MCID_HAND)


; Create macro area border with labels to enable changing the border color and line width
;createGuiRect($macroRect[0], $macroRect[1], $macroRect[2], $macroRect[3], $macroRect[4], $macroRect[5], $macroRect[6])
;GUICtrlCreateLabel($macroRect[6], $macroRect[0]+10, $macroRect[1]-8, 80, 50, $SS_CENTER) ;macro group label to properly enable changing colors
;GUICtrlSetColor(-1, $COLOR_GRAY)
;GUICtrlSetBkColor(-1, $guiBgColor)



; Create client area  border
;createGuiRect($clientRect[0], $clientRect[1], $clientRect[2], $clientRect[3], $clientRect[4], $clientRect[5], $clientRect[6])
;GUICtrlCreateLabel($clientRect[6], $clientRect[0]+10, $clientRect[1]-8, 150, 20, $SS_CENTER) ;macro group label to properly enable changing colors
;GUICtrlSetColor(-1, $COLOR_GRAY)
;GUICtrlSetBkColor(-1, $guiBgColor)


#cs
coordMode('abs')
Global $detectClientsButton = GuiFlatButton_Create("Detect clients", $settingsColumnX, 70, 150, 60)
GUICtrlSetFont(-1, 10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas") 
createShadow($detectClientsButton)
GUICtrlSetCursor ($detectClientsButton, $MCID_HAND)

Global $resetClientsButton = GuiFlatButton_Create("Reset"&@CRLF&"clients", $settingsColumnX+180, 70, 105, 60, BitOR($BS_MULTILINE , $BS_VCENTER))
GUICtrlSetFont(-1, 10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas") ;
createShadow($resetClientsButton)
GUICtrlSetCursor ($resetClientsButton, $MCID_HAND)
#ce

#cs
; Loading bar
coordMode('abs')
Global $clientSetupLoadingBar = GUICtrlCreateLabel("", $settingsColumnX, 185, 285, 20, $WS_EX_LAYERED)
GUICtrlSetColor($clientSetupLoadingBar, 0x00bfff)
GUICtrlSetFont($clientSetupLoadingBar, 12, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas") 

Global $clientSetupStatus = GUICtrlCreateLabel("✖ Game clients not set", $settingsColumnX, 145, 285, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_EX_LAYERED) )
GUICtrlSetColor($clientSetupStatus, 0xcc0000)
GUICtrlSetBkColor($clientSetupStatus, 0x111922) ; 0x333333 0xd9d9d9 0x111922
GUICtrlSetFont($clientSetupStatus, 12, $FW_BOLD, $GUI_FONTNORMAL, "Consolas") 
#ce


#cs
coordMode('rel')
Global $windowRenamingFormatLabel = GUICtrlCreateLabel("Client rename format:", 0, 80)
GUICtrlSetColor($windowRenamingFormatLabel, $COLOR_GREY)
GUICtrlSetBkColor($windowRenamingFormatLabel, $guiBgColor)


;createGuiBox(0-5, 30-5, 230+10, 20+10, $COLOR_RED)
Global $windowRenamingFormatInput = GUICtrlCreateInput( "Flyff (ROLE)", 0, 25, 230, 20, -1, BitOR($WS_EX_LAYERED, $ES_MULTILINE))
GUICtrlSetColor($windowRenamingFormatInput, $COLOR_GREY)
GUICtrlSetBkColor($windowRenamingFormatInput, $guiTextFieldBgColor)
#ce




#cs
;GUICtrlCreateLabel("(NAME=char | ROLE=main/support)", 0, 30)
;GUICtrlSetColor(-1, $COLOR_GRAY)

coordMode('abs')
GUICtrlCreateLabel("Main char:", $settingsColumnX, 295)
GUICtrlSetColor(-1, $COLOR_GREY)
coordMode('rel')
Global $mainCharNameInput = GUICtrlCreateInput( "", 135, 0, 150, 20, -1, BitOR($WS_EX_LAYERED, $ES_MULTILINE)) 
#ce


#cs
coordMode('abs')
GUICtrlCreateLabel("Support char:", $settingsColumnX, 325)
GUICtrlSetColor(-1, $COLOR_GREY)
coordMode('rel')
Global $supportCharNameInput = GUICtrlCreateInput( "", 135, 0, 150, 20, -1, BitOR($WS_EX_LAYERED, $ES_MULTILINE)) 

GUICtrlSetColor($mainCharNameInput, $COLOR_GREY)
GUICtrlSetColor($supportCharNameInput, $COLOR_GREY)
GUICtrlSetBkColor($mainCharNameInput, $guiTextFieldBgColor)
GUICtrlSetBkColor($supportCharNameInput, $guiTextFieldBgColor)

; Move ControlSend checkbox off gui, it doen't work
coordMode('abs')
Global $useControlSendInput = GUICtrlCreateCheckbox(" ", $clientRect[0], -5000, -5000, default)
coordMode('rel')
Global $useControlSendInputLabel = GUICtrlCreateLabel("ControlSend (beta)", 20, $guiOffset, default, default)
GUICtrlSetBkColor($useControlSendInputLabel, $guiBgColor)
;GUICtrlSetColor($hideTitleLabel, $guiDefaultTextColor)
GUICtrlSetColor($useControlSendInputLabel, $guiDefaultTextColor)
#ce



#cs
;Global $oldGameIconInput = GUICtrlCreateCheckbox(" ", 120, -5, 20, default)
;Global $oldGameIconLabel = GUICtrlCreateLabel("Old game icon", 0, 20, 100, default)

coordMode('abs')
Global $guiScriptNameLabelPos = ControlGetPos($mainGui, $mainGui, $guiScriptNameLabel)

;Global $idleButtonLabel = GUICtrlCreateLabel($idleHotkey & " = panic hotkey", 50, $guiScriptNameLabelPos[1]+50, $clientRect[2], 30, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_EX_LAYERED))
;GUICtrlSetColor($idleButtonLabel, 0x0099ff)


Global $helpButton = GuiFlatButton_Create("Help", $guiIconImageX + 295, $guiScriptNameLabelPos[1]-5, 50, 50)
GUICtrlSetFont(-1, 10, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas")
createShadow($helpButton, 3)
GUICtrlSetCursor ($helpButton, $MCID_HAND)


Global $toggleInputButton = GuiFlatButton_Create("[ON]", $guiIconImageX + 0, $guiScriptNameLabelPos[1]+100, $clientRect[2], 80)
createShadow($toggleInputButton)
;GUICtrlSetColor($toggleInputButton, $COLOR_WHITE)
;GuiFlatButton_SetBkColor($toggleInputButton, 0x32a852)
;GUICtrlSetBkColor($toggleInputButton, 0x32a852)
GUICtrlSetFont ($toggleInputButton, 12, $FW_NORMAL, $GUI_FONTNORMAL, "Consolas")
GUICtrlSetCursor ($toggleInputButton, $MCID_HAND)

Global $toggleInputButtonPos = ControlGetPos($mainGui, $mainGui, $toggleInputButton)


Global $scriptStatusLabel = GUICtrlCreateLabel("  ■ Macro engine ready...", $toggleInputButtonPos[0], $toggleInputButtonPos[1]+$toggleInputButtonPos[3]+10, $clientRect[2], 30, BitOR($SS_CENTERIMAGE, $WS_EX_LAYERED))
;GUICtrlSetColor($scriptStatusLabel, 0x0099ff)
GUICtrlSetColor($scriptStatusLabel, $COLOR_LIME)
GUICtrlSetBkColor($scriptStatusLabel, 0x111922)
#ce



;sGUICtrlSetDefBkColor ($guiBgColor)
GUISetIcon("files/icon.ico") 
GUISetState()
