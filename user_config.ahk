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

!q::ToggleApp("chrome.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
!`::ToggleApp("WindowsTerminal.exe", "C:\Program Files\WindowsApps\Microsoft.WindowsTerminalPreview_1.23.11752.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe", true)
!e::ToggleApp("Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")