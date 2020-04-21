;; open a global scratchpad
Pause::
  Run, "C:\Program Files (x86)\Vim\vim80\gvim.exe" --servername SCRATCHPAD --remote-tab-silent E:\scratchpad.txt
return

;;
Alt & F11::
  Run, notepad.exe,, %x%
  Tooltip %x%, 0, 0
  Winset, Alwaysontop, ON, ahk_pid %x%
  WinMove, ahk_pid %x%, 0, 0, 100, 100
return

;; toogle current window stay on top
Alt & o::
  Winset, Alwaysontop, Toggle, A
  Tooltip "Toggle Alwaysontop", 0, 0
  SetTimer, RemoveToolTip, 1000
return

RemoveToolTip:
  SetTimer, RemoveToolTip, Off
  ToolTip
return

#!Up::CenterActiveWindow() ; if win+alt is pressed
CenterActiveWindow()
{
    SysGet, WA_, MonitorWorkArea ; get the actual work area. That is, screen size w/o the taskbar.
    A_ScreenWidthWA := WA_Right - WA_Left
    A_ScreenHeightWA := WA_Bottom - WA_Top
    windowWidth := A_ScreenWidthWA * 0.5 ; desired width
    windowHeight := A_ScreenHeightWA ; desired height
    WinGetTitle, windowName, A
    WinMove, %windowName%, , A_ScreenWidthWA / 2 - (windowWidth / 2), 0, windowWidth, windowHeight
}
