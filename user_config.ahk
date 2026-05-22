#Requires AutoHotkey v2.0

; === SYMBOLS ===
; !   <- Alt
; +   <- Shift
; ^   <- Ctrl
; #   <- Win
; For more, visit https://www.autohotkey.com/docs/v2/Hotkeys.htm

!1::GoToDesktopNumber(0)
!2::GoToDesktopNumber(1)
!3::GoToDesktopNumber(2)
!4::GoToDesktopNumber(3)

!q::ToggleApp("chrome.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe")
!`::ToggleApp("WindowsTerminal.exe", "C:\Users\550017897\sdk\terminal-1.23.11752.0\WindowsTerminal.exe", true)
!e::ToggleApp("Code.exe", "C:\Users\550017897\AppData\Local\Programs\Microsoft VS Code\Code.exe")
!t::ToggleApp("ms-teams.exe", "C:\Program Files\WindowsApps\MSTeams_25185.410.3812.8024_x64__8wekyb3d8bbwe\ms-teams.exe")

SetCapsLockState "AlwaysOff"
SetStoreCapsLockMode False
CapsLock::return
CapsLock & a::Send("{Left}")
CapsLock & d::Send("{Right}")
CapsLock & w::Send("{Up}")
CapsLock & s::Send("{Down}")
CapsLock & h::Send("{Home}")
CapsLock & `;::Send("{End}")
CapsLock & q::Send("{PgUp}")
CapsLock & e::Send("{PgDn}")

; >!CapsLock::Send("{CapsLock}")
>!CapsLock::SetCapsLockState !GetKeyState("CapsLock", "T")
