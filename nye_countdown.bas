OPTION _EXPLICIT
_TITLE "NYE Countdown"
$RESIZE:OFF
SCREEN _NEWIMAGE(542, 102, 32)
_DELAY 0.1
_SCREENMOVE 3, 3
CLS

DIM SHARED Hr AS STRING
DIM SHARED Min AS STRING
DIM SHARED Sec AS STRING
DIM SHARED MA AS SINGLE
DIM SHARED CRGB AS DOUBLE
DIM SHARED b AS LONG
DIM SHARED oldb AS LONG
DIM SHARED TimerKey AS SINGLE
DIM SHARED rootpath AS STRING, fontfile AS STRING, style AS STRING, f AS LONG, GWL_STYLE AS SINGLE, WS_BORDER AS SINGLE, hwnd AS LONG, winstyle AS LONG, a AS LONG, Level AS SINGLE, FGwin AS LONG
DIM SHARED y AS LONG, C AS SINGLE, FontSize AS SINGLE, PosY AS SINGLE, K AS STRING, newb AS SINGLE, hour AS STRING, H AS INTEGER, ampm AS STRING, Null AS SINGLE, Status AS STRING

rootpath$ = ENVIRON$("SYSTEMROOT") 'normally "C:\WINDOWS"
fontfile$ = rootpath$ + "\Fonts\lucon.ttf" 'TTF file in Windows
style$ = "monospace" 'font style is not case sensitive
f& = _LOADFONT(fontfile$, 128, style$)
IF f& = -1 THEN PRINT "lucon.ttf not found!": SLEEP: SYSTEM
_FONT f&

_FONT 16

rootpath$ = ENVIRON$("SYSTEMROOT") 'normally "C:\WINDOWS"
fontfile$ = rootpath$ + "\Fonts\DS-DIGIB.TTF" 'TTF file in Windows
style$ = "monospace" 'font style is not case sensitive
f& = _LOADFONT(fontfile$, 128, style$)
IF f& = -1 THEN PRINT "DS-DIGIB.TTF not found!": SLEEP: SYSTEM
_FONT f&

' Borderless
DECLARE CUSTOMTYPE LIBRARY
    FUNCTION FindWindow& (BYVAL ClassName AS _OFFSET, WindowName$)
END DECLARE

GWL_STYLE = -16
WS_BORDER = &H800000

hwnd& = _WINDOWHANDLE 'FindWindow(0, "No Border" + CHR$(0))

winstyle& = GetWindowLongA&(hwnd&, GWL_STYLE)
a& = SetWindowLongA&(hwnd&, GWL_STYLE, winstyle& AND NOT WS_BORDER)
a& = SetWindowPos&(hwnd&, 0, 0, 0, 0, 0, 39)

' Always on top ------
CONST HWND_TOPMOST%& = -1
CONST SWP_NOSIZE%& = &H1
CONST SWP_NOMOVE%& = &H2
CONST SWP_SHOWWINDOW%& = &H40

DECLARE DYNAMIC LIBRARY "user32"
    FUNCTION SetWindowPos& (BYVAL hWnd AS LONG, BYVAL hWndInsertAfter AS _OFFSET, BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL cx AS INTEGER, BYVAL cy AS INTEGER, BYVAL uFlags AS _OFFSET)
    FUNCTION GetForegroundWindow& 'find currently focused process handle

    FUNCTION GetWindowLongA& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG)
    FUNCTION SetWindowLongA& (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG, BYVAL dwNewLong AS LONG)

    FUNCTION SetLayeredWindowAttributes& (BYVAL hwnd AS LONG, BYVAL crKey AS LONG, BYVAL bAlpha AS _UNSIGNED _BYTE, BYVAL dwFlags AS LONG)
    FUNCTION GetWindowLong& ALIAS "GetWindowLongA" (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG)
    FUNCTION SetWindowLong& ALIAS "SetWindowLongA" (BYVAL hwnd AS LONG, BYVAL nIndex AS LONG, BYVAL dwNewLong AS LONG)

END DECLARE

' Needed for acquiring the hWnd of the window
DIM SHARED Myhwnd AS LONG ' Get hWnd value
Myhwnd = _WINDOWHANDLE

Level = 200
_DELAY .1

FGwin& = GetForegroundWindow&
' Always on top ------

y& = SetWindowPos&(Myhwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW)

SetWindowOpacity Myhwnd, Level

b = _NEWIMAGE(542, 102, 32)
C = 1
FontSize = 128
PosY = -24
CRGB = _RGB(55, 238, 55)
COLOR CRGB


ON TIMER(1) Timer01
TIMER ON

DO
    K$ = UCASE$(INKEY$)
    IF K$ <> "" THEN TimerKey = 3
    IF TimerKey >= 1 THEN
        _LIMIT 30
    END IF
    IF TimerKey <= 0 THEN
        _LIMIT 3
        _DELAY .333
        IF MA > 0 THEN MA = MA - .75
    END IF

    IF K$ <> "" THEN Timer01
LOOP

FUNCTION Clock$
    hour$ = LEFT$(TIME$, 2): H% = VAL(hour$)
    Min$ = MID$(TIME$, 3, 3)
    IF H% >= 12 THEN ampm$ = " PM" ELSE ampm$ = " AM"
    IF H% > 12 THEN
        IF H% - 12 < 10 THEN hour$ = STR$(H% - 12) ELSE hour$ = LTRIM$(STR$(H% - 12))
    ELSEIF H% = 0 THEN hour$ = "12" ' midnight hour
    ELSE: IF H% < 10 THEN hour$ = STR$(H%) ' eliminate leading zeros
    END IF
    Clock$ = hour$ + Min$ + ampm$
END FUNCTION

SUB SetWindowOpacity (hWnd AS LONG, Level)
    DIM Msg AS LONG
    CONST G = -20
    CONST LWA_ALPHA = &H2
    CONST WS_EX_LAYERED = &H80000
    Msg = GetWindowLong(hWnd, G)
    Msg = Msg OR WS_EX_LAYERED
    Null = SetWindowLong(hWnd, G, Msg)
    Null = SetLayeredWindowAttributes(hWnd, 0, Level, LWA_ALPHA)
END SUB

SUB Timer01
    TimerKey = TimerKey - 1

    IF K$ <> "" THEN
        IF K$ = "C" THEN
            C = C + 1
            IF C = 2 THEN CRGB = _RGB(33, 28, 255)
            IF C = 3 THEN CRGB = _RGB(249, 17, 11)
            IF C = 4 THEN CRGB = _RGB(238, 238, 238)
            IF C = 5 THEN CRGB = _RGB(111, 116, 116)
            IF C = 6 THEN CRGB = _RGB(216, 33, 216)
            IF C = 7 THEN CRGB = _RGB(233, 238, 33)
            IF C = 8 THEN CRGB = _RGB(111, 55, 211)
            IF C = 9 THEN CRGB = _RGB(55, 128, 205)
            IF C = 10 THEN C = 1: CRGB = _RGB(55, 238, 55)
            COLOR CRGB
            Status = STR$(C)
        END IF

        IF K$ = "-" THEN
            FontSize = FontSize - 32
            IF FontSize < 32 THEN
                FontSize = 32
                newb = 0
            ELSE
                newb = 1
            END IF
            Status = STR$(FontSize)
        END IF

        IF K$ = "+" THEN
            FontSize = FontSize + 32
            IF FontSize > 256 THEN
                FontSize = 256
                newb = 0
            ELSE
                newb = 1
            END IF
            Status = STR$(FontSize)
        END IF

        IF K$ = "R" THEN _SCREENMOVE 3, 3: Level = 200: SetWindowOpacity Myhwnd, Level: Status = "Restore"
        IF _KEYDOWN(27) OR K$ = CHR$(27) THEN SYSTEM
    END IF

    IF newb = 1 THEN
        newb = 0
        oldb = b
        IF FontSize <= 32 THEN b = _NEWIMAGE(146, 44, 32): PosY = -6
        IF FontSize = 64 THEN b = _NEWIMAGE(282, 60, 32): PosY = -12
        IF FontSize = 96 THEN b = _NEWIMAGE(412, 82, 32): PosY = -18
        IF FontSize = 128 THEN b = _NEWIMAGE(542, 102, 32): PosY = -24
        IF FontSize = 160 THEN b = _NEWIMAGE(668, 130, 32): PosY = -28
        IF FontSize = 192 THEN b = _NEWIMAGE(804, 152, 32): PosY = -32
        IF FontSize = 224 THEN b = _NEWIMAGE(932, 172, 32): PosY = -36
        IF FontSize >= 256 THEN b = _NEWIMAGE(1064, 198, 32): PosY = -40
        SCREEN b
        _FREEIMAGE oldb ' Required to prevent memory leak
        f& = _LOADFONT(fontfile$, FontSize, style$)
        _FONT f&
        COLOR CRGB
    END IF

    MA = MA - .75
    IF MA >= 25 THEN MA = 25 ELSE IF MA <= 0 THEN MA = 0
    IF _KEYDOWN(18432) THEN _SCREENMOVE _SCREENX, (_SCREENY - 1) - MA: Status = STR$(_SCREENY): MA = MA + 1
    IF _KEYDOWN(19200) THEN _SCREENMOVE (_SCREENX - 1) - MA, _SCREENY: Status = STR$(_SCREENX): MA = MA + 1
    IF _KEYDOWN(20480) THEN _SCREENMOVE _SCREENX, (_SCREENY + 1) + MA: Status = STR$(_SCREENY): MA = MA + 1
    IF _KEYDOWN(19712) THEN _SCREENMOVE (_SCREENX + 1) + MA, _SCREENY: Status = STR$(_SCREENX): MA = MA + 1

    IF _KEYDOWN(18688) THEN
        Level = Level + 1
        IF Level > 255 THEN Level = 255
        SetWindowOpacity Myhwnd, Level
        Status = STR$(Level)
    END IF

    IF _KEYDOWN(20736) THEN
        Level = Level - 1
        IF Level < 32 THEN Level = 32
        SetWindowOpacity Myhwnd, Level
        Status = STR$(Level)
    END IF

    Hr = _TRIM$(STR$(23 - VAL(MID$(TIME$, 1, 2))))
    Min = _TRIM$(STR$(59 - VAL(MID$(TIME$, 4, 2))))
    Sec = _TRIM$(STR$(59 - VAL(MID$(TIME$, 7, 2))))
    IF VAL(Hr) <= 9 THEN Hr = "0" + Hr
    IF VAL(Min) <= 9 THEN Min = "0" + Min
    IF VAL(Sec) <= 9 THEN Sec = "0" + Sec

    _PRINTSTRING (10, PosY), Hr + ":" + Min + ":" + Sec

    IF TimerKey < 0 THEN
        TimerKey = 0
        _PRINTSTRING (10, 0), "          "
        _PRINTSTRING (10, PosY), Hr + ":" + Min + ":" + Sec
    ELSE
        fontfile$ = rootpath$ + "\Fonts\lucon.ttf" 'TTF file in Windows
        style$ = "monospace" 'font style is not case sensitive
        f& = _LOADFONT(fontfile$, 32, style$)
        IF f& = -1 THEN PRINT "lucon.ttf not found!": _DISPLAY: _DELAY 3: SLEEP: SYSTEM
        _FONT f&
        _PRINTSTRING (10, 0), "[" + _TRIM$(Status) + "] "
        fontfile$ = rootpath$ + "\Fonts\DS-DIGIB.TTF" 'TTF file in Windows
        style$ = "monospace" 'font style is not case sensitive
        f& = _LOADFONT(fontfile$, FontSize, style$)
        IF f& = -1 THEN PRINT "DS-DIGIB.TTF not found!": _DISPLAY: _DELAY 3: SLEEP: SYSTEM
        _FONT f&
    END IF

    _DISPLAY
    IF Hr = "00" AND Min = "00" AND Sec = "00" THEN _DELAY 60

    FGwin& = GetForegroundWindow&

    IF Myhwnd <> FGwin& THEN
        y& = SetWindowPos&(Myhwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW)
    END IF

END SUB
