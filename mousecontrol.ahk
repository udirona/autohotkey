; Using Keyboard as a Mouse
; changes by udirona
;  using wersdfxcv instead of Numblock
;  small code refactoring



; original wirtten -- by deguix
; http://www.autohotkey.com
; This script makes mousing with your keyboard almost as easy
; as using a real mouse (maybe even easier for some tasks).
; It supports up to five mouse buttons and the turning of the
; mouse wheel.  It also features customizable movement speed,
; acceleration, and "axis inversion".

/*
|  A Script file for AutoHotkey 1.0.22+ |
|    This script is an example of use of AutoHotkey. It uses |
| the remapping of numpad keys of a keyboard to transform it |
| into a mouse. Some features are the acceleration which     |
| enables you to increase the mouse movement when holding    |
| a key for a long time, and the rotation which makes the    |
| numpad mouse to "turn". I.e. NumpadDown as NumpadUp        |
| and vice-versa. See the list of keys used below:           |
|                                                            |
|------------------------------------------------------------|
| Keys                  | Description                        |
|------------------------------------------------------------|
| ScrollLock (toggle on)| Activates numpad mouse mode.       |
|-----------------------|------------------------------------|
| Numpad0               | Left mouse button click.           |
| Numpad5               | Middle mouse button click.         |
| NumpadDot             | Right mouse button click.          |
| NumpadDiv/NumpadMult  | X1/X2 mouse button click. (Win 2k+)|
| NumpadSub/NumpadAdd   | Moves up/down the mouse wheel.     |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled off) | Activates mouse movement mode.     |
|-----------------------|------------------------------------|
| NumpadEnd/Down/PgDn/  | Mouse movement.                    |
| /Left/Right/Home/Up/  |                                    |
| /PgUp                 |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled on)  | Activates mouse speed adj. mode.   |
|-----------------------|------------------------------------|
| Numpad7/Numpad1       | Inc./dec. acceleration per         |
|                       | button press.                      |
| Numpad8/Numpad2       | Inc./dec. initial speed per        |
|                       | button press.                      |
| Numpad9/Numpad3       | Inc./dec. maximum speed per        |
|                       | button press.                      |
| ^Numpad7/^Numpad1     | Inc./dec. wheel acceleration per   |
|                       | button press*.                     |
| ^Numpad8/^Numpad2     | Inc./dec. wheel initial speed per  |
|                       | button press*.                     |
| ^Numpad9/^Numpad3     | Inc./dec. wheel maximum speed per  |
|                       | button press*.                     |
| Numpad4/Numpad6       | Inc./dec. rotation angle to        |
|                       | right in degrees. (i.e. 180� =     |
|                       | = inversed controls).              |
|------------------------------------------------------------|
| * = These options are affected by the mouse wheel speed    |
| adjusted on Control Panel. if you don't have a mouse with  |
| wheel, the default is 3 +/- lines per option button press. |
o------------------------------------------------------------o
*/

;START OF CONFIG SECTION

#SingleInstance force
#MaxHotkeysPerInterval 500
#KeyHistory 0

; Using the keyboard hook to implement the Numpad hotkeys prevents
; them from interfering with the generation of ANSI characters such
; as �.  This is because AutoHotkey generates such characters
; by holding down ALT and sending a series of Numpad keystrokes.
; Hook hotkeys are smart enough to ignore such keystrokes.
#UseHook

MouseSpeed = 2
MouseAccelerationSpeed = 5
MouseMaxSpeed = 9

;Mouse wheel speed is also set on Control Panel. As that
;will affect the normal mouse behavior, the real speed of
;these three below are times the normal mouse wheel speed.
MouseWheelSpeed = 1
MouseWheelAccelerationSpeed = 1
MouseWheelMaxSpeed = 5

MouseRotationAngle = 0

MOVE_UP            = e
MOVE_DOWN          = d
MOVE_LEFT          = s
MOVE_RIGHT         = f
MOVE_UP_LEFT       = w 
MOVE_UP_RIGHT      = r
MOVE_DOWN_LEFT     = x
MOVE_DOWN_RIGHT    = c
MOUSE_LEFT_CLICK   = q
MOUSE_MIDDLE_CLICK = a
MOUSE_RIGHT_CLICK  = z

;END OF CONFIG SECTION







;This is needed or key presses would faulty send their natural
;actions. Like NumpadDiv would send sometimes "/" to the
;screen.
#InstallKeybdHook

Temp = 0
Temp2 = 0

MouseRotationAnglePart = %MouseRotationAngle%
;Divide by 45� because MouseMove only supports whole numbers,
;and changing the mouse rotation to a number lesser than 45�
;could make strange movements.
;
;For example: 22.5� when pressing NumpadUp:
;  First it would move upwards until the speed
;  to the side reaches 1
MouseRotationAnglePart /= 45

MouseCurrentAccelerationSpeed = 0
MouseCurrentSpeed = %MouseSpeed%

MouseWheelCurrentAccelerationSpeed = 0
MouseWheelCurrentSpeed = %MouseSpeed%

SetKeyDelay, -1
SetMouseDelay, -1


;; Hotkey, *NumpadIns, ButtonLeftClickIns
;; Hotkey, *NumpadClear, ButtonMiddleClickClear
;; Hotkey, *NumpadDel, ButtonRightClickDel
;; Hotkey, *NumpadDiv, ButtonX1Click
;; Hotkey, *NumpadMult, ButtonX2Click
;;
;; Hotkey, *NumpadSub, ButtonWheelUp
;; Hotkey, *NumpadAdd, ButtonWheelDown
;;
 Hotkey, *%MOVE_UP%, ButtonUp
 Hotkey, *%MOVE_DOWN%, ButtonDown
 Hotkey, *%MOVE_LEFT%, ButtonLeft
 Hotkey, *%MOVE_RIGHT%, ButtonRight
 Hotkey, *%MOVE_UP_LEFT%, ButtonUpLeft
 Hotkey, *%MOVE_UP_RIGHT%, ButtonUpRight
 Hotkey, *%MOVE_DOWN_LEFT%, ButtonDownLeft
 Hotkey, *%MOVE_DOWN_RIGHT%, ButtonDownRight
 Hotkey, *%MOUSE_LEFT_CLICK%, ButtonLeftClick
 Hotkey, *%MOUSE_MIDDLE_CLICK%, ButtonMiddleClick
 Hotkey, *%MOUSE_RIGHT_CLICK%, ButtonRightClick
;; Hotkey, *, ButtonDownLeft
;; Hotkey, *, ButtonDownRight
;;
;; Hotkey, Numpad8, ButtonSpeedUp
;; Hotkey, Numpad2, ButtonSpeedDown
;; Hotkey, Numpad7, ButtonAccelerationSpeedUp
;; Hotkey, Numpad1, ButtonAccelerationSpeedDown
;; Hotkey, Numpad9, ButtonMaxSpeedUp
;; Hotkey, Numpad3, ButtonMaxSpeedDown
;;
;; Hotkey, Numpad6, ButtonRotationAngleUp
;; Hotkey, Numpad4, ButtonRotationAngleDown
;;
;; Hotkey, !Numpad8, ButtonWheelSpeedUp
;; Hotkey, !Numpad2, ButtonWheelSpeedDown
;; Hotkey, !Numpad7, ButtonWheelAccelerationSpeedUp
;; Hotkey, !Numpad1, ButtonWheelAccelerationSpeedDown
;; Hotkey, !Numpad9, ButtonWheelMaxSpeedUp
;; Hotkey, !Numpad3, ButtonWheelMaxSpeedDown

Gosub, ~ScrollLock  ; Initialize based on current ScrollLock state.
return

;Key activation support

~ScrollLock::
  ; Wait for it to be released because otherwise the hook state gets reset
  ; while the key is down, which causes the up-event to get suppressed,
  ; which in turn prevents toggling of the ScrollLock state/light:
  KeyWait, ScrollLock
  GetKeyState, ScrollLockState, ScrollLock, T
  if ScrollLockState = D
  {
    ToolTip, Mouse is on 
    Hotkey, *%MOVE_UP%, On
    Hotkey, *%MOVE_DOWN%, On
    Hotkey, *%MOVE_LEFT%, On
    Hotkey, *%MOVE_RIGHT%, On
    Hotkey, *%MOVE_UP_LEFT%, On
    Hotkey, *%MOVE_UP_RIGHT%, On
    Hotkey, *%MOVE_DOWN_LEFT%, On 
    Hotkey, *%MOVE_DOWN_RIGHT%, On
    Hotkey, *%MOUSE_LEFT_CLICK%, On 
    Hotkey, *%MOUSE_MIDDLE_CLICK%, On
    Hotkey, *%MOUSE_RIGHT_CLICK%, On

  }
  else
  {
    ToolTip 
    Hotkey, *%MOVE_UP%, Off
    Hotkey, *%MOVE_DOWN%, Off
    Hotkey, *%MOVE_LEFT%, Off
    Hotkey, *%MOVE_RIGHT%, Off
    Hotkey, *%MOVE_UP_LEFT%, Off
    Hotkey, *%MOVE_UP_RIGHT%, Off
    Hotkey, *%MOVE_DOWN_LEFT%, Off
    Hotkey, *%MOVE_DOWN_RIGHT%, Off
    Hotkey, *%MOUSE_LEFT_CLICK%, Off 
    Hotkey, *%MOUSE_MIDDLE_CLICK%, Off
    Hotkey, *%MOUSE_RIGHT_CLICK%, Off
  }
return


;Mouse click support

ButtonLeftClick:
  GetKeyState, already_down_state, LButton
  if already_down_state = D
    return
  Button2 = Numpad0
  ButtonClick = Left
  Goto ButtonClickStart

ButtonLeftClickIns:
  GetKeyState, already_down_state, LButton
  if already_down_state = D
    return
  Button2 = NumpadIns
  ButtonClick = Left
  Goto ButtonClickStart

ButtonMiddleClick:
  GetKeyState, already_down_state, MButton
  if already_down_state = D
    return
  Button2 = Numpad5
  ButtonClick = Middle
  Goto ButtonClickStart

ButtonMiddleClickClear:
  GetKeyState, already_down_state, MButton
  if already_down_state = D
    return
  Button2 = NumpadClear
  ButtonClick = Middle
  Goto ButtonClickStart

ButtonRightClick:
  GetKeyState, already_down_state, RButton
  if already_down_state = D
    return
  Button2 = NumpadDot
  ButtonClick = Right
  Goto ButtonClickStart

ButtonRightClickDel:
  GetKeyState, already_down_state, RButton
  if already_down_state = D
    return
  Button2 = NumpadDel
  ButtonClick = Right
  Goto ButtonClickStart

ButtonX1Click:
  GetKeyState, already_down_state, XButton1
  if already_down_state = D
    return
  Button2 = NumpadDiv
  ButtonClick = X1
  Goto ButtonClickStart

ButtonX2Click:
  GetKeyState, already_down_state, XButton2
  if already_down_state = D
    return
  Button2 = NumpadMult
  ButtonClick = X2
  Goto ButtonClickStart

ButtonClickStart:
  MouseClick, %ButtonClick%,,, 1, 0, D
  SetTimer, ButtonClickEnd, 10
return

ButtonClickEnd:
  GetKeyState, kclickstate, %Button2%, P
  if kclickstate = D
    return

  SetTimer, ButtonClickEnd, Off
  MouseClick, %ButtonClick%,,, 1, 0, U
return

;Mouse movement support
ButtonSpeedUp:
  MouseSpeed++
  ToolTip, Mouse speed: %MouseSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonSpeedDown:
  if MouseSpeed > 1
    MouseSpeed--
  if MouseSpeed = 1
    ToolTip, Mouse speed: %MouseSpeed% pixel
  else
    ToolTip, Mouse speed: %MouseSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonAccelerationSpeedUp:
  MouseAccelerationSpeed++
  ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonAccelerationSpeedDown:
  if MouseAccelerationSpeed > 1
    MouseAccelerationSpeed--
  if MouseAccelerationSpeed = 1
    ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixel
  else
    ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonMaxSpeedUp:
  MouseMaxSpeed++
  ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonMaxSpeedDown:
  if MouseMaxSpeed > 1
    MouseMaxSpeed--
  if MouseMaxSpeed = 1
    ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixel
  else
    ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
  SetTimer, RemoveToolTip, 1000
return

ButtonRotationAngleUp:
  MouseRotationAnglePart++
  if MouseRotationAnglePart >= 8
    MouseRotationAnglePart = 0
  MouseRotationAngle = %MouseRotationAnglePart%
  MouseRotationAngle *= 45
  ToolTip, Mouse rotation angle: %MouseRotationAngle%�
  SetTimer, RemoveToolTip, 1000
return

ButtonRotationAngleDown:
  MouseRotationAnglePart--
  if MouseRotationAnglePart < 0
    MouseRotationAnglePart = 7
  MouseRotationAngle = %MouseRotationAnglePart%
  MouseRotationAngle *= 45
  ToolTip, Mouse rotation angle: %MouseRotationAngle%�
  SetTimer, RemoveToolTip, 1000
return


ButtonUp:
ButtonDown:
ButtonLeft:
ButtonRight:
ButtonUpLeft:
ButtonUpRight:
ButtonDownLeft:
ButtonDownRight:
              if Button <> 0
              {
                IfNotInString, A_ThisHotkey, %Button%
                {
                  MouseCurrentAccelerationSpeed = 0
                  MouseCurrentSpeed = %MouseSpeed%
                }
              }
              StringReplace, Button, A_ThisHotkey, *

              ButtonAccelerationStart:
              if MouseAccelerationSpeed >= 1
              {
                if MouseMaxSpeed > %MouseCurrentSpeed%
                {
                  Temp = 0.001
                  Temp *= %MouseAccelerationSpeed%
                  MouseCurrentAccelerationSpeed += %Temp%
                  MouseCurrentSpeed += %MouseCurrentAccelerationSpeed%
                }
              }

              ;MouseRotationAngle convertion to speed of button direction
              {
                MouseCurrentSpeedToDirection = %MouseRotationAngle%
                MouseCurrentSpeedToDirection /= 90.0
                Temp = %MouseCurrentSpeedToDirection%

                if (Temp >= 0) and (Temp < 1)
                {
                    MouseCurrentSpeedToDirection = 1
                    MouseCurrentSpeedToDirection -= %Temp%
                    Goto EndMouseCurrentSpeedToDirectionCalculation
                }
                if (Temp >= 1) and (Temp < 2)
                {
                    MouseCurrentSpeedToDirection = 0
                    Temp -= 1
                    MouseCurrentSpeedToDirection -= %Temp%
                    Goto EndMouseCurrentSpeedToDirectionCalculation
                }
                if (Temp >= 2) and (Temp < 3)
                {
                    MouseCurrentSpeedToDirection = -1
                    Temp -= 2
                    MouseCurrentSpeedToDirection += %Temp%
                    Goto EndMouseCurrentSpeedToDirectionCalculation
                }
                if (Temp >= 3) and (Temp < 4)
                {
                    MouseCurrentSpeedToDirection = 0
                    Temp -= 3
                    MouseCurrentSpeedToDirection += %Temp%
                    Goto EndMouseCurrentSpeedToDirectionCalculation
                }
              }

              EndMouseCurrentSpeedToDirectionCalculation:
              { ;MouseRotationAngle convertion to speed of 90 degrees to right
                MouseCurrentSpeedToSide = %MouseRotationAngle%
                MouseCurrentSpeedToSide /= 90.0
                Temp = %MouseCurrentSpeedToSide%
                Transform, Temp, mod, %Temp%, 4

                if (Temp >= 0) and (Temp < 1)
                {
                    MouseCurrentSpeedToSide = 0
                    MouseCurrentSpeedToSide += %Temp%
                    Goto EndMouseCurrentSpeedToSideCalculation
                }
                if (Temp >= 1) and (Temp < 2)
                {
                    MouseCurrentSpeedToSide = 1
                    Temp -= 1
                    MouseCurrentSpeedToSide -= %Temp%
                    Goto EndMouseCurrentSpeedToSideCalculation
                }
                if (Temp >= 2) and (Temp < 3)
                {
                    MouseCurrentSpeedToSide = 0
                    Temp -= 2
                    MouseCurrentSpeedToSide -= %Temp%
                    Goto EndMouseCurrentSpeedToSideCalculation
                }
                if (Temp >= 3) and (Temp < 4)
                {
                    MouseCurrentSpeedToSide = -1
                    Temp -= 3
                    MouseCurrentSpeedToSide += %Temp%
                    Goto EndMouseCurrentSpeedToSideCalculation
                }
              }

              EndMouseCurrentSpeedToSideCalculation:
                MouseCurrentSpeedToDirection *= %MouseCurrentSpeed%
                MouseCurrentSpeedToSide *= %MouseCurrentSpeed%
                Temp = %MouseRotationAnglePart%
                Transform, Temp, Mod, %Temp%, 2

                if (Button = MOVE_UP)
                {
                  if Temp = 1
                  {
                    MouseCurrentSpeedToSide *= 2
                    MouseCurrentSpeedToDirection *= 2
                  }
                  MouseCurrentSpeedToDirection *= -1
                  MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
                }
                else if (Button = MOVE_DOWN)
                {
                  if Temp = 1
                  {
                    MouseCurrentSpeedToSide *= 2
                    MouseCurrentSpeedToDirection *= 2
                  }
                  MouseCurrentSpeedToSide *= -1
                  MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
                }
                else if (Button = MOVE_LEFT)
                {
                  if Temp = 1
                  {
                    MouseCurrentSpeedToSide *= 2
                    MouseCurrentSpeedToDirection *= 2
                  }
                  MouseCurrentSpeedToSide *= -1
                  MouseCurrentSpeedToDirection *= -1
                  MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
                }
                else if (Button = MOVE_RIGHT)
                {
                  if Temp = 1
                  {
                    MouseCurrentSpeedToSide *= 2
                    MouseCurrentSpeedToDirection *= 2
                  }
                  MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
                }
                else if (Button = MOVE_UP_RIGHT)
                {
                  Temp = (%MouseCurrentSpeedToDirection% - %MouseCurrentSpeedToSide%) * -1
                  Temp2 = (%MouseCurrentSpeedToDirection% + %MouseCurrentSpeedToSide%) * -1
                  MouseMove, %Temp%, %Temp2%, 0, R
                }
                else if (Button = MOVE_UP_LEFT)
                {
                  Temp = %MouseCurrentSpeedToDirection% + %MouseCurrentSpeedToSide%
                  Temp2 = (%MouseCurrentSpeedToDirection% - %MouseCurrentSpeedToSide%) * -1
                  MouseMove, %Temp%, %Temp2%, 0, R
                }
                else if (Button = MOVE_DOWN_LEFT)
                {
                  Temp = (%MouseCurrentSpeedToDirection% + %MouseCurrentSpeedToSide%) * -1
                  Temp2 = %MouseCurrentSpeedToDirection% - %MouseCurrentSpeedToSide%
                  MouseMove, %Temp%, %Temp2%, 0, R
                }
                else if (Button = MOVE_DOWN_RIGHT)
                {
                  Temp = (%MouseCurrentSpeedToDirection% - %MouseCurrentSpeedToSide%)
                  Temp2 *= -1
                  Temp2 = %MouseCurrentSpeedToDirection% + %MouseCurrentSpeedToSide%
                  MouseMove, %Temp%, %Temp2%, 0, R
                }
                SetTimer, ButtonAccelerationEnd, 10
return


ButtonAccelerationEnd:
  GetKeyState, kstate, %Button%, P
  if kstate = D
    Goto ButtonAccelerationStart

  SetTimer, ButtonAccelerationEnd, Off
  MouseCurrentAccelerationSpeed = 0
  MouseCurrentSpeed = %MouseSpeed%
  Button = 0
return

;Mouse wheel movement support

ButtonWheelSpeedUp:
  MouseWheelSpeed++
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  MouseWheelSpeedReal = %MouseWheelSpeed%
  MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
  ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelSpeedDown:
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  if MouseWheelSpeedReal > %MouseWheelSpeedMultiplier%
  {
    MouseWheelSpeed--
    MouseWheelSpeedReal = %MouseWheelSpeed%
    MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
  }
  if MouseWheelSpeedReal = 1
    ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% line
  else
    ToolTip, Mouse wheel speed: %MouseWheelSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelAccelerationSpeedUp:
  MouseWheelAccelerationSpeed++
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
  MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
  ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelAccelerationSpeedDown:
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  if MouseWheelAccelerationSpeed > 1
  {
    MouseWheelAccelerationSpeed--
    MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
    MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
  }
  if MouseWheelAccelerationSpeedReal = 1
    ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% line
  else
    ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelMaxSpeedUp:
  MouseWheelMaxSpeed++
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
  MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
  ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelMaxSpeedDown:
  RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
  if MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
  if MouseWheelMaxSpeed > 1
  {
    MouseWheelMaxSpeed--
    MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
    MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
  }
  if MouseWheelMaxSpeedReal = 1
    ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% line
  else
    ToolTip, Mouse wheel maximum speed: %MouseWheelMaxSpeedReal% lines
  SetTimer, RemoveToolTip, 1000
return

ButtonWheelUp:
ButtonWheelDown:
  if Button <> 0
  {
    if Button <> %A_ThisHotkey%
    {
      MouseWheelCurrentAccelerationSpeed = 0
      MouseWheelCurrentSpeed = %MouseWheelSpeed%
    }
  }
  StringReplace, Button, A_ThisHotkey, *

  ButtonWheelAccelerationStart:
  if MouseWheelAccelerationSpeed >= 1
  {
    if MouseWheelMaxSpeed > %MouseWheelCurrentSpeed%
    {
      Temp = 0.001
      Temp *= %MouseWheelAccelerationSpeed%
      MouseWheelCurrentAccelerationSpeed += %Temp%
      MouseWheelCurrentSpeed += %MouseWheelCurrentAccelerationSpeed%
    }
  }

  if Button = NumpadSub
    MouseClick, WheelUp,,, %MouseWheelCurrentSpeed%, 0, D
  else if Button = NumpadAdd
    MouseClick, WheelDown,,, %MouseWheelCurrentSpeed%, 0, D

  SetTimer, ButtonWheelAccelerationEnd, 100
return

ButtonWheelAccelerationEnd:
  GetKeyState, kstate, %Button%, P
  if kstate = D
    Goto ButtonWheelAccelerationStart

  MouseWheelCurrentAccelerationSpeed = 0
  MouseWheelCurrentSpeed = %MouseWheelSpeed%
  Button = 0
return

RemoveToolTip:
  SetTimer, RemoveToolTip, Off
  ToolTip
return
