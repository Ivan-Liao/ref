#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;# AHK specific
    ^Esc::ExitApp
    return


::rungen::
    Run, "C://Users/Ivan Liao/Documents/general.ahk"
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
::eap::
    SendInput, ivanhliao@gmail.com
    return
::xxe::
    SendInput, ivan.liao@xselltechnologies.com
    return
::xxp::
    Sendinput, eggSeLL3781*t
    return
::xxpt::
    SendInput, eggSeLL3781*tt
    return
    ;## date and time strings
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
F5 & F1::
    SendInput, (╯°□°）╯︵ ┻━┻
    return
;## Shrug
F5 & F2::
    SendInput, ¯\_(ツ)_/¯
    return
;## Happy
F5 & F3::
    SendInput, (づ｡◕‿‿◕｡)づ
    return
;## Annoyed
F5 & F4::
    SendInput, (ಠ_ಠ)
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