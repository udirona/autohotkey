#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook

#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




;; deactivate capslock completely
SetCapslockState, AlwaysOff

;; remap capslock to hyper
;; if capslock is toggled, remap it to esc

;; note: must use tidle prefix to fire hotkey once it is pressed
;; not until the hotkey is released
~Capslock::
    ;; must use downtemp to emulate hyper key, you cannot use down in this case 
    ;; according to https://autohotkey.com/docs/commands/Send.htm, downtemp is as same as down except
    ;;   for ctrl/alt/shift/win keys
    ;; in those cases, downtemp tells subsequent sends that the key is not permanently down, and may be 
    ;; released whenever a keystroke calls for it.
    ;; for example, Send {Ctrl Downtemp} followed later by Send {Left} would produce a normal {Left}
    ;; keystroke, not a Ctrl{Left} keystroke
    Send {Ctrl DownTemp}{Shift DownTemp}{Alt DownTemp}{LWin DownTemp}
    KeyWait, Capslock
    Send {Ctrl Up}{Shift Up}{Alt Up}{LWin Up}
    if (A_PriorKey = "Capslock") {
        Send {Esc}
    }
return

;; vim navigation with hyper
~Capslock & h:: Send {Left}
~Capslock & l:: Send {Right}
~Capslock & k:: Send {Up}
~Capslock & j:: Send {Down}
~Capslock & w:: Send ^{Right}
~Capslock & e:: Send ^{Right}
~Capslock & b:: Send ^{Left}
~Capslock & n:: Send {Up}
~Capslock & p:: Send {Down}

~Capslock & 0:: Send {Home}
~Capslock & $:: Send {End}
~Capslock & u:: Send {PgUp}
~Capslock & d:: Send {PgDn}
~Capslock & 1:: Send {F1}
~Capslock & 2:: Send {F2}
~Capslock & 3:: Send {F3}
~Capslock & 4:: Send {F4}
~Capslock & 5:: Send {F5}
~Capslock & 6:: Send {F6}
~Capslock & 7:: Send {F7}
~Capslock & 8:: Send {F8}
~Capslock & 9:: Send {F9}


;; Reload this script
~Capslock & r:: 
  Reload
return

;; popular hotkeys with hyper
~Capslock & c:: Send ^{c}
~Capslock & v:: Send ^{v}

