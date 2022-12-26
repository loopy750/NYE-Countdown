Option _Explicit
_Title "NYE Countdown"
$Resize:Off
Screen _NewImage(542, 102, 32)
_Delay 0.1
_ScreenMove 3, 3
Cls

Dim Shared Hr As String
Dim Shared Min As String
Dim Shared Sec As String
Dim Shared MA As Single
Dim Shared CRGB As Double
Dim Shared b As Long
Dim Shared oldb As Long
Dim Shared TimerKey As Single
Dim Shared CoreFont As String
Dim Shared MaxFontSize As Single
Dim Shared CoreFontOffest, CoreFontWidthOffset, CoreFontHeightOffset As Single
Dim Shared rootpath As String, fontfile As String, style As String, f As Long, GWL_STYLE As Single, WS_BORDER As Single, hwnd As Long, winstyle As Long, a As Long, Level As Single, FGwin As Long
Dim Shared y As Long, C As Single, FontSize As Single, PosY As Single, K As String, newb As Single, hour As String, H As Integer, ampm As String, Null As Single, Status As String

CoreFont = "DS-DIGIB.TTF"

rootpath$ = Environ$("SYSTEMROOT") 'normally "C:\WINDOWS"
fontfile$ = rootpath$ + "\Fonts\lucon.ttf" 'TTF file in Windows
style$ = "monospace" 'font style is not case sensitive
f& = _LoadFont(fontfile$, 128, style$)
If f& = -1 Then Print "lucon.ttf not found!": Sleep: System
_Font f&

_Font 16

CoreFontOffest = 1
CoreFontWidthOffset = 1
CoreFontHeightOffset = 1

rootpath$ = Environ$("SYSTEMROOT") 'normally "C:\WINDOWS"
fontfile$ = rootpath$ + "\Fonts\" + CoreFont 'TTF file in Windows
style$ = "monospace" 'font style is not case sensitive
f& = _LoadFont(fontfile$, 128, style$)
If f& = -1 Then
    Print
    Print "   " + CoreFont + " not found, using default font!"
    Print
    Print "   https://github.com/loopy750";
    Sleep 10
    Cls
    CoreFont = "lucon.ttf"
    fontfile$ = rootpath$ + "\Fonts\" + CoreFont 'TTF file in Windows
    style$ = "monospace" 'font style is not case sensitive
    f& = _LoadFont(fontfile$, 128, style$)
    CoreFontOffest = 3.6
    CoreFontWidthOffset = 1.18
    CoreFontHeightOffset = 1.13
    Screen _NewImage(542 * CoreFontWidthOffset, 102 * CoreFontHeightOffset, 32)
End If

Print
Print "   NYE Countdown"
Print "   -------------"
Print
Print "   https://github.com/loopy750";
Sleep 3
Cls

_Font f&

' Borderless
Declare CustomType Library
    Function FindWindow& (ByVal ClassName As _Offset, WindowName$)
End Declare

GWL_STYLE = -16
WS_BORDER = &H800000

hwnd& = _WindowHandle 'FindWindow(0, "No Border" + CHR$(0))

winstyle& = GetWindowLongA&(hwnd&, GWL_STYLE)
a& = SetWindowLongA&(hwnd&, GWL_STYLE, winstyle& And Not WS_BORDER)
a& = SetWindowPos&(hwnd&, 0, 0, 0, 0, 0, 39)

' Always on top ------
Const HWND_TOPMOST%& = -1
Const SWP_NOSIZE%& = &H1
Const SWP_NOMOVE%& = &H2
Const SWP_SHOWWINDOW%& = &H40

Declare Dynamic Library "user32"
    Function SetWindowPos& (ByVal hWnd As Long, Byval hWndInsertAfter As _Offset, Byval X As Integer, Byval Y As Integer, Byval cx As Integer, Byval cy As Integer, Byval uFlags As _Offset)
    Function GetForegroundWindow& 'find currently focused process handle

    Function GetWindowLongA& (ByVal hwnd As Long, Byval nIndex As Long)
    Function SetWindowLongA& (ByVal hwnd As Long, Byval nIndex As Long, Byval dwNewLong As Long)

    Function SetLayeredWindowAttributes& (ByVal hwnd As Long, Byval crKey As Long, Byval bAlpha As _Unsigned _Byte, Byval dwFlags As Long)
    Function GetWindowLong& Alias "GetWindowLongA" (ByVal hwnd As Long, Byval nIndex As Long)
    Function SetWindowLong& Alias "SetWindowLongA" (ByVal hwnd As Long, Byval nIndex As Long, Byval dwNewLong As Long)

End Declare

' Needed for acquiring the hWnd of the window
Dim Shared Myhwnd As Long ' Get hWnd value
Myhwnd = _WindowHandle

Level = 200
_Delay .1

FGwin& = GetForegroundWindow&
' Always on top ------

y& = SetWindowPos&(Myhwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW)

SetWindowOpacity Myhwnd, Level

MaxFontSize = 384
b = _NewImage(542 * CoreFontWidthOffset, 102 * CoreFontHeightOffset, 32)
C = 1
FontSize = 128
PosY = -24 / CoreFontOffest
CRGB = _RGB(55, 238, 55)
Color CRGB


On Timer(1) Timer01
Timer On

Do
    K$ = UCase$(InKey$)
    If K$ <> "" Then TimerKey = 3
    If TimerKey >= 1 Then
        _Limit 30
    End If
    If TimerKey <= 0 Then
        _Limit 3
        _Delay .333
        If MA > 0 Then MA = MA - .75
    End If

    If K$ <> "" Then Timer01
Loop

Function Clock$
    hour$ = Left$(Time$, 2): H% = Val(hour$)
    Min$ = Mid$(Time$, 3, 3)
    If H% >= 12 Then ampm$ = " PM" Else ampm$ = " AM"
    If H% > 12 Then
        If H% - 12 < 10 Then hour$ = Str$(H% - 12) Else hour$ = LTrim$(Str$(H% - 12))
    ElseIf H% = 0 Then hour$ = "12" ' midnight hour
    Else: If H% < 10 Then hour$ = Str$(H%) ' eliminate leading zeros
    End If
    Clock$ = hour$ + Min$ + ampm$
End Function

Sub SetWindowOpacity (hWnd As Long, Level)
    Dim Msg As Long
    Const G = -20
    Const LWA_ALPHA = &H2
    Const WS_EX_LAYERED = &H80000
    Msg = GetWindowLong(hWnd, G)
    Msg = Msg Or WS_EX_LAYERED
    Null = SetWindowLong(hWnd, G, Msg)
    Null = SetLayeredWindowAttributes(hWnd, 0, Level, LWA_ALPHA)
End Sub

Sub Timer01
    TimerKey = TimerKey - 1

    If K$ <> "" Then
        If K$ = "C" Then
            C = C + 1
            If C = 2 Then CRGB = _RGB(33, 28, 255)
            If C = 3 Then CRGB = _RGB(249, 17, 11)
            If C = 4 Then CRGB = _RGB(238, 238, 238)
            If C = 5 Then CRGB = _RGB(111, 116, 116)
            If C = 6 Then CRGB = _RGB(216, 33, 216)
            If C = 7 Then CRGB = _RGB(233, 238, 33)
            If C = 8 Then CRGB = _RGB(111, 55, 211)
            If C = 9 Then CRGB = _RGB(55, 128, 205)
            If C = 10 Then C = 1: CRGB = _RGB(55, 238, 55)
            Color CRGB
            Status = Str$(C)
        End If

        If K$ = "-" Then
            FontSize = FontSize - 32
            If FontSize < 32 Then
                FontSize = 32
                newb = 0
            Else
                newb = 1
            End If
            Status = Str$(FontSize)
        End If

        If K$ = "+" Then
            FontSize = FontSize + 32
            If FontSize > MaxFontSize Then
                FontSize = MaxFontSize
                newb = 0
            Else
                newb = 1
            End If
            Status = Str$(FontSize)
        End If

        If K$ = "R" Then _ScreenMove 3, 3: Level = 200: SetWindowOpacity Myhwnd, Level: Status = "Restore"
        If _KeyDown(27) Or K$ = Chr$(27) Then System
    End If

    If newb = 1 Then
        newb = 0
        oldb = b
        If FontSize <= 32 Then b = _NewImage(146 * CoreFontWidthOffset, 44 * CoreFontHeightOffset, 32): PosY = -6 / CoreFontOffest
        If FontSize = 64 Then b = _NewImage(282 * CoreFontWidthOffset, 60 * CoreFontHeightOffset, 32): PosY = -12 / CoreFontOffest
        If FontSize = 96 Then b = _NewImage(412 * CoreFontWidthOffset, 82 * CoreFontHeightOffset, 32): PosY = -18 / CoreFontOffest
        If FontSize = 128 Then b = _NewImage(542 * CoreFontWidthOffset, 102 * CoreFontHeightOffset, 32): PosY = -24 / CoreFontOffest
        If FontSize = 160 Then b = _NewImage(668 * CoreFontWidthOffset, 130 * CoreFontHeightOffset, 32): PosY = -28 / CoreFontOffest
        If FontSize = 192 Then b = _NewImage(804 * CoreFontWidthOffset, 152 * CoreFontHeightOffset, 32): PosY = -32 / CoreFontOffest
        If FontSize = 224 Then b = _NewImage(932 * CoreFontWidthOffset, 172 * CoreFontHeightOffset, 32): PosY = -36 / CoreFontOffest
        If FontSize = 256 Then b = _NewImage(1064 * CoreFontWidthOffset, 198 * CoreFontHeightOffset, 32): PosY = -40 / CoreFontOffest
        If FontSize = 288 Then b = _NewImage(1196 * CoreFontWidthOffset, 224 * CoreFontHeightOffset, 32): PosY = -44 / CoreFontOffest
        If FontSize = 320 Then b = _NewImage(1328 * CoreFontWidthOffset, 248 * CoreFontHeightOffset, 32): PosY = -48 / CoreFontOffest
        If FontSize = 352 Then b = _NewImage(1456 * CoreFontWidthOffset, 272 * CoreFontHeightOffset, 32): PosY = -52 / CoreFontOffest
        If FontSize >= 384 Then b = _NewImage(1580 * CoreFontWidthOffset, 296 * CoreFontHeightOffset, 32): PosY = -56 / CoreFontOffest
        Screen b
        _FreeImage oldb ' Required to prevent memory leak
        f& = _LoadFont(fontfile$, FontSize, style$)
        _Font f&
        Color CRGB
    End If

    MA = MA - .75
    If MA >= 25 Then MA = 25 Else If MA <= 0 Then MA = 0
    If _KeyDown(18432) Then _ScreenMove _ScreenX, (_ScreenY - 1) - MA: Status = Str$(_ScreenY): MA = MA + 1
    If _KeyDown(19200) Then _ScreenMove (_ScreenX - 1) - MA, _ScreenY: Status = Str$(_ScreenX): MA = MA + 1
    If _KeyDown(20480) Then _ScreenMove _ScreenX, (_ScreenY + 1) + MA: Status = Str$(_ScreenY): MA = MA + 1
    If _KeyDown(19712) Then _ScreenMove (_ScreenX + 1) + MA, _ScreenY: Status = Str$(_ScreenX): MA = MA + 1

    If _KeyDown(18688) Then
        Level = Level + 1
        If Level > 255 Then Level = 255
        SetWindowOpacity Myhwnd, Level
        Status = Str$(Level)
    End If

    If _KeyDown(20736) Then
        Level = Level - 1
        If Level < 32 Then Level = 32
        SetWindowOpacity Myhwnd, Level
        Status = Str$(Level)
    End If

    Hr = _Trim$(Str$(23 - Val(Mid$(Time$, 1, 2))))
    Min = _Trim$(Str$(59 - Val(Mid$(Time$, 4, 2))))
    Sec = _Trim$(Str$(59 - Val(Mid$(Time$, 7, 2))))
    If Val(Hr) <= 9 Then Hr = "0" + Hr
    If Val(Min) <= 9 Then Min = "0" + Min
    If Val(Sec) <= 9 Then Sec = "0" + Sec

    _PrintString (10, PosY), Hr + ":" + Min + ":" + Sec

    If TimerKey < 0 Then
        TimerKey = 0
        _PrintString (10, 0), "          "
        _PrintString (10, PosY), Hr + ":" + Min + ":" + Sec
    Else
        fontfile$ = rootpath$ + "\Fonts\lucon.ttf" 'TTF file in Windows
        style$ = "monospace" 'font style is not case sensitive
        f& = _LoadFont(fontfile$, 32, style$)
        If f& = -1 Then Print "lucon.ttf not found!": _Display: _Delay 3: Sleep: System
        _Font f&
        _PrintString (10, 0), "[" + _Trim$(Status) + "] "
        fontfile$ = rootpath$ + "\Fonts\" + CoreFont 'TTF file in Windows
        style$ = "monospace" 'font style is not case sensitive
        f& = _LoadFont(fontfile$, FontSize, style$)
        If f& = -1 Then Print CoreFont + " not found!": _Display: _Delay 3: Sleep: System
        _Font f&
    End If

    _Display
    If Hr = "00" And Min = "00" And Sec = "00" Then _Delay 60

    FGwin& = GetForegroundWindow&

    If Myhwnd <> FGwin& Then
        y& = SetWindowPos&(Myhwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW)
    End If

End Sub
