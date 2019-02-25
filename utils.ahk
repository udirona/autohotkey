;; open a global scratchpad
Pause::
  Run, "C:\Program Files (x86)\Vim\vim80\gvim.exe" --servername SCRATCHPAD --remote-tab-silent E:\scratchpad.txt E:\currentwork.sql
return

;; toogle current window stay on top
Alt & o::Winset, Alwaysontop, Toggle, A

#!Up::CenterActiveWindow() ; if win+alt is pressed
CenterActiveWindow()
{
    SysGet, WA_, MonitorWorkArea ; get the actual work area. That is, screen size w/o the taskbar.
    A_ScreenWidthWA := WA_Right - WA_Left
    A_ScreenHeightWA := WA_Bottom - WA_Top
    windowWidth := A_ScreenWidthWA * 0.7 ; desired width
    windowHeight := A_ScreenHeightWA ; desired height
    WinGetTitle, windowName, A
    WinMove, %windowName%, , A_ScreenWidthWA / 2 - (windowWidth / 2), 0, windowWidth, windowHeight
}
