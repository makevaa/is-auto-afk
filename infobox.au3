
;not used, infobox is placed under overlay image
Func setInfoBoxPosition()
 	activateClient()
	Local $result = findImage("files/img/stats.png")		
	If $result = false Then
		msgbox (0, "Error" , "setTooltipCoordinates() function error: files/img/stats.png image was not found on visible screen. The function was exited early to avoid crash.")
		return false ;image was not found, return early
	EndIf

	;Local $statsImgCoords[2] = $result
	;$tooltipX = $statsImgCoords[0] - 40
	;$tooltipY = $statsImgCoords[1] - 205
		;put tooltip on top-left of client instead over minimap
	Local $clientInfo = WinGetPos($client)
	Local $clientX = $clientInfo[0]
	Local $clientY = $clientInfo[1]
	Local $clientW = $clientInfo[2]
	Local $clientH = $clientInfo[3]
	;$tooltipX = $clientX + 20
	;$tooltipY = $clientY + 55
EndFunc


Func createInfoBox($str, $x, $y, $w = 300, $h = 150, $fontSize = "Default")
	;SplashTextOn ( "title", "text", w, h, x, y, opt, "fontname", fontsize, fontweight )
	Local $font = "Default"
 	$font = "Consolas"
	Local  $splash = SplashTextOn("splash", $str, $w, $h, $x, $y, BitOr($DLG_TEXTLEFT, $DLG_NOTITLE) , $font, $fontSize )
    return $splash
EndFunc


Func updateInfoBox($infoBoxHandle, $str)
	ControlSetText($infoBoxHandle, "", "Static1", $str)
EndFunc


Func removeInfoBox()
	ToolTip("")
	SplashOff()
EndFunc