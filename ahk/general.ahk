#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;# AHK specific
    ^Esc::ExitApp
    return


::rungen::
    Run, "C:\Users\ivanh\OneDrive\Desktop"
    return


^!+1::
    MouseGetPos, xpos, ypos
    clipboard := ypos
    Sleep, 250
    clipboard := xpos
    MsgBox, The cursor is at X: %xpos% Y: %ypos%
    return


;# string shortcuts
;## emails and passwords
::emp::
    SendInput, ivanhliao@gmail.com
    return

::addy:: 
    Send 7443 Pensacola Pl Gainesville, VA 20155
    return

;# datetimes
F1 & F2::
    FormatTime, xx,, yyyy-MM-dd
    SendInput, %xx%
    return
F1 & F3::
    FormatTime, xx,, yyyy-MM-ddTHH:mm
    SendInput, %xx%
    return
;# System shortcuts
;## Sleep computer
F2 & F1::
   DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
   return

;# Emojis
;## Table flip
::tableflip::
    Send ({U+256F}{U+00B0}{U+25A1}{U+00B0}{U+FF09}{U+256F}{U+FE35} {U+253B}{U+2501}{U+253B}
    return
;## Shrug
::itswe::
    Send {U+00AF}\_({U+30C4})_/{U+00AF}
    return
;## Happy
::letsgo::
    Send ({U+3065}{U+FF61}{U+25D5}{U+203F}{U+203F}{U+25D5}{U+FF61}){U+3065}
    return
;## Annoyed
::sus::
    Send ({U+0CA0}_{U+0CA0})
    return

;# SQL shortcuts
::sel*::
    SendInput, SELECT *
    SendInput, `nFROM 
    SendInput, `nLIMIT 20
    SendInput, `n`;
    return
::selfil::
    Sleep, 100
    SendInput, SELECT *
    SendInput, `nFROM 
    SendInput, `nWHERE 1 = 1
    SendInput, `n{space}{space}{space}{space}AND 
    SendInput, `nLIMIT 20
    Sleep, 200 ;needed for shift tab to register below
    SendInput, {Shift Down}{Tab}{Shift Up}
    SendInput, `n`;
    return
::seljoin::
    Sleep, 100
    SendInput, SELECT *
    SendInput, `nFROM 
    SendInput, `nLEFT JOIN 
    SendInput, `n{space 4}ON A = B
    SendInput, `nWHERE 1 = 1
    SendInput, `n{space 4}AND 
    SendInput, `nLIMIT 20
    Sleep, 50 ;needed for shift tab to register below
    SendInput, {Shift Down}{Tab}{Shift Up}
    SendInput, `n`;
    return