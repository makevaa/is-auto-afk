
#include <GuiComboBoxEx.au3>
#include "GUIComboBoxColor.au3"
#include "GUIComboBoxFont.au3"

Example()

Func Example()
        ; Create GUI
        Local $hGUI = GUICreate("ComboBox Create (v" & @AutoItVersion & ")", 400, 296)
        Local $hCombo = _GUICtrlComboBox_Create($hGUI, "", 2, 2, 396, 296)
		Local $aC1Args = _GUICtrlComboBoxEx_SetColor($hCombo, 0x000000, 0xc0c0c0, 0xc0c0c0, 0x000000)
		_GUICtrlComboBoxEx_SetFont($hCombo, 10, $FW_NORMAL, $GUI_FONTITALIC, "Arial Bold", $PROOF_QUALITY)

        Local $iCombo2 = GUICtrlCreateCombo("", 2, 30, 396, 296); _GUICtrlComboBox_Create($hGUI, "", 2, 27, 396, 296)
		_GUICtrlComboBoxEx_SetColor($iCombo2, 0x0000ff, 0xffffff)
        GUISetState(@SW_SHOW)
        ; Add files
        _GUICtrlComboBox_BeginUpdate($hCombo)
        _GUICtrlComboBox_AddDir($hCombo, "", $DDL_DRIVES, False)
        _GUICtrlComboBox_AddDir(GUICtrlGetHandle($iCombo2), "", $DDL_DRIVES, False)
        _GUICtrlComboBox_EndUpdate($hCombo)

        ; Loop until the user exits.
        Do
        Until GUIGetMsg() = $GUI_EVENT_CLOSE
        GUIDelete()
EndFunc   ;==>Example