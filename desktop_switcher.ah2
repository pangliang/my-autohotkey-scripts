; AutoHotkey v2 script
SetWorkingDir(A_ScriptDir)

; Path to the DLL, relative to the script
VDA_PATH := A_ScriptDir . "\VirtualDesktopAccessor.dll"
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", VDA_PATH, "Ptr")

GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopCount", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")
GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetCurrentDesktopNumber", "Ptr")
GetWindowDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetWindowDesktopNumber", "Ptr")
IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnCurrentVirtualDesktop", "Ptr")
IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnDesktopNumber", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
IsPinnedWindowProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsPinnedWindow", "Ptr")
GetDesktopNameProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopName", "Ptr")
SetDesktopNameProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "SetDesktopName", "Ptr")
CreateDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "CreateDesktop", "Ptr")
RemoveDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "RemoveDesktop", "Ptr")

; On change listeners
RegisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "RegisterPostMessageHook", "Ptr")
UnregisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "UnregisterPostMessageHook", "Ptr")

GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num, "Int")
    return
}

GetCurrentDesktopNumber() {
    global GetCurrentDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    return current
}

GetDesktopName(num) {
    global GetDesktopNameProc
    utf8_buffer := Buffer(1024, 0)
    ran := DllCall(GetDesktopNameProc, "Int", num, "Ptr", utf8_buffer, "Ptr", utf8_buffer.Size, "Int")
    name := StrGet(utf8_buffer, 1024, "UTF-8")
    return name
}

SetDesktopName(num, name) {
    global SetDesktopNameProc
    OutputDebug(name)
    name_utf8 := Buffer(1024, 0)
    StrPut(name, name_utf8, "UTF-8")
    ran := DllCall(SetDesktopNameProc, "Int", num, "Ptr", name_utf8, "Int")
    return ran
}

GetWindowDesktopNumber(hwnd) {
    global GetWindowDesktopNumberProc
    desktop_num := DllCall(GetWindowDesktopNumberProc, "Ptr", hwnd, "Int")
    return desktop_num

}

IsWindowOnCurrentVirtualDesktop(hwnd) {
    global IsWindowOnCurrentVirtualDesktopProc
    ran := DllCall(IsWindowOnCurrentVirtualDesktopProc, "Ptr", hwnd, "Int")
    return ran
}

MoveWindowToDesktopNumber(hwnd, desktop_num) {
    global MoveWindowToDesktopNumberProc
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", hwnd, "Int", desktop_num, "Int")
}

; SetDesktopName(0, "It works! 🐱")

DllCall(RegisterPostMessageHookProc, "Ptr", A_ScriptHwnd, "Int", 0x1400 + 30, "Int")
OnMessage(0x1400 + 30, OnChangeDesktop)
OnChangeDesktop(wParam, lParam, msg, hwnd) {
    Critical(1)
    OldDesktop := wParam + 1
    NewDesktop := lParam + 1
    Name := GetDesktopName(NewDesktop - 1)

    OutputDebug("Desktop changed to " Name " from " OldDesktop " to " NewDesktop)
}

ToggleApp(exeName, launchPath, moveToCurrentDesktop:=false) {
    DetectHiddenWindows(true)

    currentDesktopNumber := GetCurrentDesktopNumber()
    anyWindowActive := WinActive("ahk_exe " . exeName)

    ids := WinGetList("ahk_exe " . exeName)

    if ids.Length == 0 {
        Run(launchPath)
        return
    }

    for id in ids {
        title := WinGetTitle(id)
        isActive := WinActive(id)
        windowsDesktopNumber := GetWindowDesktopNumber(id)
        OutputDebug("Window " id ", title: " title ", is active: " isActive ", desktop: " windowsDesktopNumber)

        if windowsDesktopNumber == -1 {
            continue
        }

        if currentDesktopNumber != windowsDesktopNumber && moveToCurrentDesktop {
            MoveWindowToDesktopNumber(id, currentDesktopNumber)
            WinActivate(id)
            continue
        }
        if anyWindowActive {
            WinMinimize(id)
            WinMoveTop(id)
        }else {
            WinActivate(id)
        }
    }
}

#Include %A_ScriptDir%\user_config.ah2

