#include <Misc.au3>
#include <TrayConstants.au3>
#include <WinAPISys.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>
#include <GuiComboBox.au3>


_Singleton("Заголовок конфигуратора")
TrayTip("Отслеживание окна конфигуратора включено", "Отслеживание окна конфигуратора включено", 3, $TIP_ICONASTERISK + $TIP_NOSOUND);

Global $aHandleList[1000];
Global $aTitleList[1000];
$aHandleList[0] = 0;

While 1
   SetTitle()
   UpdateTitle()
   Sleep(500)
WEnd

Func UpdateTitle()
   Local $aList = WinList("[REGEXPTITLE: - Конфигуратор - ; CLASS:V8TopLevelFrame]");

   For $i = 1 To $aList[0][0]
	  For $j = 1 To $aHandleList[0]
		 If $aList[$i][1] = $aHandleList[$j] Then
			WinSetTitle ($aList[$i][1], "", $aTitleList[$j] & " - " & StringRegExpReplace($aList[$i][0], " - Конфигуратор - ", " - !Конфигуратор - " , 1));
			ExitLoop;
		 EndIf
	  Next
   Next

EndFunc

Func SetTitle()
   ; Retrieve a list of window handles.
   Local $aList = WinList("[REGEXPTITLE:^Конфигуратор - ; CLASS:V8TopLevelFrame]");
   Local $sText = "";

   ; Loop through the array displaying only visable windows with a title.
   For $i = 1 To $aList[0][0]

	  For $j = 1 To $aHandleList[0]
		 If $aList[$i][1] = $aHandleList[$j] Then
			WinSetTitle ($aList[$i][1], "", $aTitleList[$j] & " - !" & $aList[$i][0]);
			ContinueLoop 2;
		 EndIf
	  Next

	  If WinActive($aList[$i][1]) = 0 Then ;Чтобы не моргало окнами
		 ContinueLoop
	  EndIf
	  Sleep(200);

	  Local $iPID = WinGetProcess($aList[$i][1])
	  Local $sText = _WinAPI_GetProcessCommandLine($iPID)
	  $sText = StringRegExpReplace ($sText, ".*\/IBName""(.*?)""(\s.*|$)", "$1")
	  $sText = StringReplace ($sText, """""", """")
	  $aHandleList[0] += 1;
	  $aHandleList[$aHandleList[0]] = $aList[$i][1]
	  $aTitleList[$aHandleList[0]] = $sText

	  ConsoleWrite("Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & " О программе: " & $sText & "");
	  WinSetTitle ($aList[$i][1], "", $sText & " - !" & $aList[$i][0]);
   Next

EndFunc