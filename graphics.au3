_GDIPlus_StartUp()


Func drawGraphics()
	; Draw  banner image
	Local $bannerImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & $guiBannerImage)
	Local $bannerImageGraphic = _GDIPlus_GraphicsCreateFromHWND($mainGui)
	_GDIPlus_GraphicsDrawImageRect($bannerImageGraphic, $bannerImage, $guiBannerImageX, $guiBannerImageY, $guiBannerImageW, $guiBannerImageH)



	; Draw icon image 


	Local $iconImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & $guiIconImage)
	Local $iconImageGraphic = _GDIPlus_GraphicsCreateFromHWND($mainGui)
	_GDIPlus_GraphicsDrawImageRect($iconImageGraphic, $iconImage, $guiIconImageX, $guiIconImageY, $guiIconImageW, $guiIconImageH)



	_GDIPlus_ImageDispose($bannerImage)
	_GDIPlus_Graphicsdispose($bannerImageGraphic)

	_GDIPlus_ImageDispose($iconImage)
	_GDIPlus_Graphicsdispose($iconImageGraphic)
	;_GDIPlus_Shutdown()
EndFunc
