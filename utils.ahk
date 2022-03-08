OSD(text)
{
	#Persistent
	; borderless, no progressbar, font size 25, color text 009900
	Progress, hide Y50 W200 b zh0 cwFFFFFF FM20 CT00BB00,, %text%, AutoHotKeyProgressBar, Backlash BRK
	WinSet, TransColor, FFFFFF 255, AutoHotKeyProgressBar
	Progress, show
	SetTimer, RemoveToolTip, 1000

	Return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	Progress, Off
	return
}

;; get current key states
;;^F12::
;;  a := GetKeyState("Alt")
;;  OSD("Alt " . a)
;;return

;; open a global scratchpad
Pause::
  Run, "C:\Program Files (x86)\Vim\vim80\gvim.exe" --servername SCRATCHPAD --remote-tab-silent E:\scratchpad.txt
return

;; toogle current window stay on top
Alt & o::
  Winset, Alwaysontop, Toggle, A
  OSD("Toggle Always on top")
  ;;Tooltip "Toggle Alwaysontop", 0, 0
  ;;SetTimer, RemoveToolTip, 1000
return

#!Up::CenterActiveWindow() ; if win+alt is pressed
CenterActiveWindow()
{
    SysGet, WA_, MonitorWorkArea ; get the actual work area. That is, screen size w/o the taskbar.
    A_ScreenWidthWA := WA_Right - WA_Left
    A_ScreenHeightWA := WA_Bottom - WA_Top
    windowWidth := A_ScreenWidthWA * 0.67 ; desired width
    windowHeight := A_ScreenHeightWA ; desired height
    WinGetTitle, windowName, A
    WinMove, %windowName%, , A_ScreenWidthWA / 2 - (windowWidth / 2), 0, windowWidth, windowHeight
}

Alt & F1::
  Run, mstsc
return
