#Persistent
SetTitleMatchMode, 2
return

;;;;;;;;;;;;;;;;;;;;;
WriteLog(text) {
	FileAppend, % A_NowUTC ": " text "`n", .\logfile.txt ; can provide a full path to write to another directory
}

;;;;;;;;;;;;;;;;;;;;;
RunWaitOne(command) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("C:\Windows\system32\cmd.exe" " /C " command)
    return exec.StdOut.ReadAll()
}

;;;;;;;;;;;;;;;;;;;;
Slepp() {
    Random, n, 5, 15
    Sleep, (1000 * n)
}

;;;;;;;;;;;;;;;;;;;;
ListTitles() {
    WinGet windows, List
    Loop %windows% {
	    id := windows%A_Index%
	    WinGetTitle wt, ahk_id %id%
	    r .= wt . "`n"
    }
    return %r%
}


;;;;;;;;;;;;;;; PROCEDURE: sample_brave ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
::sample_brave::
Run, brave.exe
return
;;;;;;;;;;;;;;; END OF: run_brave ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;; PROCEDURE: Esc ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Esc::
break_loop := 1
return
;;;;;;;;;;;;;;; END OF: Esc ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;; PROCEDURE: run_brave ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
::run_brave::

; get initial add count
db_file_name := "/path/to/database.sqlite"
command := "python.exe .\get_offer_count.py "
initial_ad_count := RunWaitOne(command . """" db_file_name """")

; put up the shield
WinGet, wList, List, ahk_class Notepad
if !wList { ; if wList is empty/zero (no Notepad windows exist)
  MsgBox, 4, , There are no instances of Notepad open.  Would you like to open a new instance?
  IfMsgBox Yes
    Run, notepad.exe
}
if (wList = 1) { 
  WinActivate, % "ahk_id " wList1
}

; launch brave
Run, brave.exe
Slepp()

Loop 1000 {

    ; get search term
    search_term := RunWaitOne("python.exe .\get_search_keyword.py raw.html")
    Slepp()

    ; position mouse for a serach entry
    #IfWinActive, Brave
    MouseMove, 450, 50
    MouseClick, Left
    
    ; clear search
    #IfWinActive, Brave
    Send, {Ctrl down}a{Ctrl up}
    Send, {Backspace}

    ; enter term and perform search
    #IfWinActive, Brave
    Send, %search_term%
    Send, {Enter}
    Slepp()

    ; run an ad check
    new_ad_count := RunWaitOne(command . """" db_file_name """")

    ; if found, position the mouse, click the add and close it after a delay
    if(initial_ad_count < new_ad_count) {
        initial_ad_count := new_ad_count
        Sleep, 1000
        MouseMove, 1425, 885
        MouseClick, Left
        Slepp()
        Send, {Ctrl down}w{Ctrl up}

        ;;WriteLog(" add clicked. total add count " . initial_ad_count)
    }

    if(break_loop == 1) {
        break
    }

    Sleep, 1000
    
}
;;;;;;;;;;;;;;;;;;;;;;;; END OF: run_brave ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Send, {Ctrl down}w{Ctrl up}
MsgBox, Done
ExitApp, 0
