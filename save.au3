
Func saveSettings()
	Local $file = $configFile

	IniWrite($file, "settings", "windowRenamingFormat", GUICtrlRead($windowRenamingFormatInput))
	
	IniWrite($file, "settings", "hideTitle", 0)
	IniWrite($file, "settings", "hideIcon", 0)
	IniWrite($file, "settings", "useControlSend", 0)
	;IniWrite($file, "settings", "useOldGameIcon", 0)
	If GUICtrlRead($hideTitle) = $GUI_CHECKED Then IniWrite($file, "settings", "hideTitle", 1)
	If GUICtrlRead($hideIcon) = $GUI_CHECKED Then IniWrite($file, "settings", "hideIcon", 1)
	If GUICtrlRead($useControlSendInput) = $GUI_CHECKED Then IniWrite($file, "settings", "useControlSend", 1)
	;If GUICtrlRead($oldGameIconInput) = $GUI_CHECKED Then IniWrite($file, "settings", "useOldGameIcon", 1)
EndFunc



Func loadSettings($file)
	;GUICtrlSetState($windowRenamingFormatInput, IniRead($file, "settings", "windowRenamingFormat", "Flyff (ROLE)"))

	_GUICtrlEdit_SetText($windowRenamingFormatInput, IniRead($file, "settings", "windowRenamingFormat", "Flyff (ROLE)"))

	GUICtrlSetState($hideTitle, $GUI_UNCHECKED)
	GUICtrlSetState($hideIcon, $GUI_UNCHECKED)
	GUICtrlSetState($useControlSendInput, $GUI_UNCHECKED)
	;GUICtrlSetState($oldGameIconInput, $GUI_UNCHECKED)
	If IniRead($file, "settings", "hideTitle", 1) = 1 Then GUICtrlSetState($hideTitle, $GUI_CHECKED)
	If IniRead($file, "settings", "hideIcon", 0) = 1 Then GUICtrlSetState($hideIcon, $GUI_CHECKED)
	If IniRead($file, "settings", "useControlSend", 0) = 1 Then GUICtrlSetState($useControlSendInput, $GUI_CHECKED)
	;If IniRead($file, "settings", "useOldGameIcon", 0) = 1 Then GUICtrlSetState($oldGameIconInput, $GUI_CHECKED)
EndFunc



Func saveHotkeys()
	Local $file = $configFile
	;dynamically save macro hotkeys 
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("macroHotkey" & $num)
		Local $hotkey = GUICtrlRead($elem)
		IniWrite($file, "settings", "macroHotkey" & $num, $hotkey)

	Next

	;dynamically save macro target clients
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("macroTargetClient" & $num)
		Local $targetClient = GUICtrlRead($elem)
		IniWrite($file, "settings", "macroTargetClient" & $num, $targetClient)
	Next

	; Save "minimize after" macro settings
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("minimizeAfter" & $num)

		Local $value = 0
		If GUICtrlRead($elem) = $GUI_CHECKED Then 
			$value = 1
		EndIf

		IniWrite($file, "settings", "macroMinimize" & $num, $value)
	Next
EndFunc


Func loadHotkeys($file)
	; dynamically load macrohotkeys (F-keys)
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("macroHotkey" & $num)
		GUICtrlSetData ($elem, IniRead($file, "settings", "macroHotkey" & $num, "F" & $num))
	Next
 
	;dynamically load macro target clients
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("macroTargetClient" & $num)
		GUICtrlSetData ($elem, IniRead($file, "settings", "macroTargetClient" & $num, "Support client"))
	Next


	; Load "minimize after" settings for macros
	For $i = 0 To $macroAmount-1 Step +1	
		Local $num = String($i+1)
		Local $elem = Eval("minimizeAfter" & $num)

		Local $value = IniRead($file, "settings", "macroMinimize"&$num, 0)
		
		GUICtrlSetState($elem, $GUI_UNCHECKED)
		If $value = 1 Then 
			GUICtrlSetState($elem, $GUI_CHECKED)
		EndIf
	Next

EndFunc