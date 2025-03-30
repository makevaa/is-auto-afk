
; Handles to the windows
Global $mainClient = -1
Global $supportClient = -1

; Change client window titles to these
Global $mainClientNameEdit = "Flyff (main)"
Global $supportClientNameEdit = "Flyff (support)"

; The un-edited game client window titels
Global $mainClientNameOrig = "-1"
Global $supportClientNameOrig = "-1"

;Global $clientsNotSetLabel = "✖ clients not set"
;Global $clientsFound = 0

Func playDetectAnimation()
	Local $dur = 300 ;ms
	Local $steps = 33
	Local $stepWait = Floor($dur/$steps)
	Local $str = ""

	;✔ Found 2 game client
	;#####################

	;blue: 
	GUICtrlSetColor($clientSetupStatus, 0x00bfff)
	GUICtrlSetData ($clientSetupStatus, "Detecting...")

	GUICtrlSetData ($clientSetupLoadingBar, "")

	For $i = 0 To $steps-1 Step +1
		GUICtrlSetData ($clientSetupLoadingBar, $str)
		$str = $str & "█" ;█ # ☠ ✖ ♕ ▒
		sleep($stepWait)
	Next

	sleep(100)
	GUICtrlSetData ($clientSetupLoadingBar, "")
EndFunc

; Set game clients if they are open
Func detectClients()
	;MsgBox(0, 'Stop here', 'stopHere(), going to idle()')

	resetClients()

	playDetectAnimation()

	Local $mainCharName = GUICtrlRead($mainCharNameInput)
	Local $supportCharName = GUICtrlRead($supportCharNameInput)

	Local $mainClientName = $mainCharName & " - Flyff Universe"
	Local $supportClientName = $supportCharName & " - Flyff Universe"

	Local $clientAmount = 0

	Local $windowRenamingFormat = GUICtrlRead($windowRenamingFormatInput)



	If WinExists($mainClientName) Then
		$mainClient = WinGetHandle($mainClientName)
		$mainClientNameOrig = $mainClientName

		Local $newTitle = $windowRenamingFormat
		$newTitle = StringReplace ( $newTitle, "NAME", $mainCharName)
		$newTitle = StringReplace ( $newTitle, "ROLE", "Main")
		WinSetTitle($mainClient, "", $newTitle)
		$clientAmount += 1
	EndIf

	If WinExists($supportClientName) Then
		$supportClient = WinGetHandle($supportClientName)
		$supportClientNameOrig = $supportClientName


		Local $newTitle = $windowRenamingFormat
		$newTitle = StringReplace ( $newTitle, "NAME", $supportCharName)
		$newTitle = StringReplace ( $newTitle, "ROLE", "Support")
		WinSetTitle($supportClient, "", $newTitle)
		$clientAmount += 1
	EndIf


	Local $clientsWereFound = $clientAmount > 0
	clientSetupStatusLabel($clientsWereFound, $clientAmount)

EndFunc

; Set client status GUI element text and styles
Func clientSetupStatusLabel($clientsWereFound=false, $clientAmount=0) 
	;Local $bgColorNormal = 0x333333
	;Local $bgColorSuccess = 0x00cc00
	;Local $textRed = 0xcc0000
	;Local $textDark = 0x000000

	Local $text = ""

	If $clientsWereFound Then
		$text = "✔ Found " & String($clientAmount) & " game client"
		If ($clientAmount > 1) Then $text = $text & "s"  ;add "s" if more than 1 client

		
		GUICtrlSetColor($clientSetupStatus, 0x00cc00) ; black= 0x000000
		;GUICtrlSetBkColor($clientSetupStatus, 0x00cc00) ;lime= 0x00cc00
	Else
		$text = "✖ No game clients found"
		GUICtrlSetColor($clientSetupStatus, 0xcc0000)
		GUICtrlSetBkColor($clientSetupStatus, 0x111922)	
	EndIf

	GUICtrlSetData ($clientSetupStatus, $text)

EndFunc


	

Func resetClients()
	clientSetupStatusLabel("reset")

	If WinExists($mainClient) Then
		WinSetTitle($mainClient, "", $mainClientNameOrig)
		WinSetTitle($mainClient, "", $mainClientNameOrig)
	EndIf

	If WinExists($supportClient) Then
		WinSetTitle($supportClient, "", $supportClientNameOrig)
	EndIf

	$mainClient = -1
	$supportClient = -1

	GUICtrlSetData ($clientSetupStatus, "✖ Game clients not set")
	GUICtrlSetColor($clientSetupStatus, 0xcc0000)
	GUICtrlSetBkColor($clientSetupStatus, 0x111922)
EndFunc


Func activateClient($targetStr)
	$targetStr = StringLower($targetStr)
	Local $client

	If $targetStr="main client" Or $targetStr="main"  Then
		$client = $mainClient
	ElseIf $targetStr="support client" Or $targetStr="support" Then
		$client = $supportClient
	Else
		return false
	EndIf

	If WinExists($client) And WinGetTitle("[ACTIVE]") <> WinGetTitle($client) Then
		WinActivate($client)
		;WinWaitActive($client) ;could slow down too much: "window is polled every 250 milliseconds or so." -autoit docs
	Else
		;client doesn't exists
	EndIf
EndFunc


Func minimizeClient($targetClient)
	WinSetState ($targetClient, "", @SW_MINIMIZE )
EndFunc





