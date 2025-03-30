
Func saveSettings()
	Local $file = $configFile


	IniWrite($file, "settings", "hideTitle", 0)
	IniWrite($file, "settings", "hideIcon", 0)

	If GUICtrlRead($hideTitle) = $GUI_CHECKED Then IniWrite($file, "settings", "hideTitle", 1)
	If GUICtrlRead($hideIcon) = $GUI_CHECKED Then IniWrite($file, "settings", "hideIcon", 1)
EndFunc



Func loadSettings($file)
	GUICtrlSetState($hideTitle, $GUI_UNCHECKED)
	GUICtrlSetState($hideIcon, $GUI_UNCHECKED)

	If IniRead($file, "settings", "hideTitle", 1) = 1 Then GUICtrlSetState($hideTitle, $GUI_CHECKED)
	If IniRead($file, "settings", "hideIcon", 0) = 1 Then GUICtrlSetState($hideIcon, $GUI_CHECKED)
EndFunc


