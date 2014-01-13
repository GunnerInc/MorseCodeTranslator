include masm32rt.inc

toMorseCode PROTO lpszText:DWORD
toPlainText PROTO lpszMorse_Code:DWORD
CenterWindow PROTO mainWndHndl:DWORD,targetWndHndl:DWORD
SaveToFile PROTO lpszText:DWORD,lpszMorse:DWORD

.data
;               Alpha
szA             db  ".-", 0
szB             db  "-...", 0
szC             db  "-.-.", 0
szD             db  "-..", 0
szE             db  ".", 0
szF             db  "..-.", 0
szG             db  "--.", 0
szH             db  "....", 0
szI             db  "..", 0
szJ             db  ".---", 0
szK             db  "-.-", 0
szL             db  ".-..", 0
szM             db  "--", 0
szN             db  "-.", 0
szO             db  "---", 0
szP             db  ".--.", 0
szQ             db  "--.-", 0
szR             db  ".-.", 0
szS             db  "...", 0
szT             db  "-", 0
szU             db  "..-", 0
szV             db  "...-", 0
szW             db  ".--", 0
szX             db  "-..-", 0
szY             db  "-.--", 0
szZ             db  "--..", 0
;               Numeric
sz0             db  "-----", 0
sz1             db  ".----", 0
sz2             db  "..---", 0
sz3             db  "...--", 0
sz4             db  "....-", 0
sz5             db  ".....", 0
sz6             db  "-....", 0
sz7             db  "--...", 0
sz8             db  "---..", 0
sz9             db  "----.", 0
;               Special
szDot           db  ".-.-.-", 0
szComma         db  "--..--", 0
szQuestion      db  "..--..", 0
szApost         db  ".----.", 0
szSpace         db  32, 0
szMenu          db  "What would you like to convert?", 13, 10
                db  "(T)ext to Morse", 13, 10
                db  "(M)orse to Text", 13, 10
                db  "'Esc' to exit",13, 10
szPrompt        db  ">", 0
szTextPrompt    db  "Enter text to convert (128 chars max)", 13, 10, 0
szMorsePrompt   db  "Enter morse code to convert (128 chars max)", 13, 10, 0
szAgain         db  13, 10, "Again Y/N (S)ave>" ,0
CRLF            db  13, 10, 0
szEmptyString   db  "Uh, I cannot convert an empty string!", 13, 10, 0
szTitle         db  "codeprada PHP Challenge, Morse Code Translator", 0
szDlgFilter     db  "Text Files", 0, "*.txt", 0, 0
szDlgExt        db  "txt", 0
szTitleSave     db  "Save output to file", 0
;               Lookup table - pointers to valid chars
MorseTable      dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                dd offset szSpace,0,0,0,0,0,0,offset szApost,0,0,0,0, offset szComma,0, offset szDot,0
			    dd offset sz0, offset sz1, offset sz2, offset sz3, offset sz4, offset sz5, offset sz6, offset sz7, offset sz8, offset sz9,0,0,0,0,0, offset szQuestion 
			    dd 0,offset szA, offset szB, offset szC, offset szD, offset szE, offset szF, offset szG, offset szH, offset szI, offset szJ, offset szK, offset szL, offset szM, offset szN, offset szO
			    dd offset szP, offset szQ, offset szR, offset szS, offset szT, offset szU, offset szV, offset szW, offset szX, offset szY, offset szZ,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			    dd 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
MorseTableSize  equ ($ - MorseTable) /4

.data?
hHeap           dd  ?
lpInput         dd  ?

.code
MorseCodeTranslator:
    invoke  GetProcessHeap
    mov     hHeap, eax                  
    
    ; lets center the console window to desktop
    invoke  GetConsoleWindow
    xchg    eax, edi

    invoke  GetDesktopWindow
    invoke  CenterWindow, eax, edi
    
    ; macro to set console caption    
    SetConsoleCaption offset szTitle
    
PrintMenu:
    print offset szMenu                         ; print is a macro to simplify console writting

MenuSelection:
    getkey                                      ; get keypress from console
    .if eax == "T" || eax == "t"                ; if it is t...
        print   "Text to Morse", 13, 10
        print   offset szTextPrompt
	    TextPrompt:
	        print   offset szPrompt
	        mov     lpInput, input()            ; get text 
	        invoke  szTrim, lpInput             ; trim leading and trailing spaces
	        invoke  szLen, lpInput
	        .if eax == 0
	            print offset szEmptyString      ; uh, oh, empty string go again
	            jmp     TextPrompt
	        .endif
	        invoke  toMorseCode, lpInput        ; convert it
	        xchg    eax, ebx
	        print   ebx                         ; print it
	        
    .elseif eax == "M" || eax == "m"            ; if char is a m
        print   "Morse to Text", 13, 10
        print   offset szMorsePrompt
	    MorsePrompt:
	        print   offset szPrompt
	        mov     lpInput, input()
	        invoke  szTrim, lpInput
	        invoke  szLen, lpInput
	        .if eax == 0
	            print offset szEmptyString
	            jmp     MorsePrompt
	        .endif
	        invoke  szCatStr, lpInput, offset szSpace
	        invoke  toPlainText, lpInput
	        xchg    eax, ebx
	        print   ebx
            
    .elseif eax == 27
        jmp     GoodBye                         ; esc selected
        
    .else
        jmp     MenuSelection                   ; all others just loop back to getkey
    .endif
    
    print offset szAgain                        ; want to go again?
SelectAgain:
    getkey
    .if eax == "Y" || eax == "y"                ; after each selection, free our returned buffer
        invoke  HeapFree, hHeap, 0, ebx
        cls
        jmp     PrintMenu
        
    .elseif eax == "N" || eax == "n"
        invoke  HeapFree, hHeap, 0, ebx
        print   offset CRLF
        
    .elseif eax == "S" || eax == "s"
        invoke  SaveToFile, lpInput, ebx
        invoke  HeapFree, hHeap, 0, ebx
        cls  
        jmp     PrintMenu
    .else
        jmp     SelectAgain
    .endif

GoodBye:
    invoke  ExitProcess, 0

COMMENT !
#############################################################
toMorseCode - Converts text to morse code

In:     lpszText = Pointer to buffer containing string to convert      
Returns:
        Pointer to buffer containing morse code
        **Free with HeapFree when done.
############################################################!  
toMorseCode proc uses esi edi ebx lpszText:DWORD
    
    mov     esi, lpszText
    invoke  szUpper, esi                        ; Convert string to uppercase
    invoke  szLen, esi                          ; get length
    shl     eax, 3                              ; multiply length by 8
    invoke  HeapAlloc, hHeap, HEAP_ZERO_MEMORY, eax
    xchg    eax, edi                            ; save pointer
    lea     ebx, MorseTable                     ; get address of lookup table
    
ConvertNext:
    movzx   eax, byte ptr [esi]                 ; get char at current pointer
    test    eax, eax                            ; is it zero?
    jz      Done                                ; yup, goodbye
    cmp     eax, 32                             ; is it a space
    je      DoSpace                             ; must be
    
    mov     ecx, [ebx + 4 * eax]                ; get pointer to morse char from table index in eax
    test    ecx, ecx                            ; is it a valid pointer
    jz      NextChar                            ; nope
    jmp     GoodChar
    
DoSpace:
    invoke  szCatStr, edi, offset szSpace       ; must be a space, append a space to our out buffer
    jmp     NextChar                            ;
    
GoodChar:
    invoke  szMultiCat, 2, edi, ecx, offset szSpace ; append morse char and space to our out buffer

NextChar:
    inc     esi                                 ; increase our string pointer
    jmp     ConvertNext

Done:
    xchg    edi, eax                            ; move converted morse buffer pointer to eax for return
    ret
toMorseCode endp  


COMMENT !
#############################################################
toPlainText - Converts morse code to text

In:     lpszMorse_Code = Pointer to buffer containing morse code to convert      
Returns:
        Pointer to buffer containing morse code
        **Free with HeapFree when done.
############################################################! 
toPlainText proc uses esi edi ebx lpszMorse_Code
local   RetBuf:DWORD ; pointer to converted buffer
local   TempBuf[8]:BYTE ; temp buf to hold current morse char

    mov     esi, lpszMorse_Code         ; put addres of morse sting in esi
    lea     ebx, TempBuf                ; get address of TempBuf
    
    invoke  szLen, esi                  ; get lenght of morse string
    invoke  HeapAlloc, hHeap, HEAP_ZERO_MEMORY, eax ; and create buffer to hold it
    xchg    eax, edi                    ; buffer pointer
    mov     RetBuf, edi                 ; buffer pointer for return
    
NextCode:
    movzx   eax, byte ptr [esi]         ; get current byte at current pointer
    cmp     eax, 32                     ; is it a space?
    je      GetMorseIndex               ; yes, got morse letter
    test    eax, eax                    ; byte a zero?
    jz      MorseDone                   ; yep, end of buffer
    mov     byte ptr [ebx], al          ; move byte to our buffer
    inc     esi                         ; increase morse pointer
    inc     ebx                         ; increase return pointer
    jmp     NextCode                    ; get next byte
    
GetMorseIndex:                          
    mov     byte ptr [ebx], 0           ; NULL term our temp buffer
    lea     ebx, TempBuf                ; get start address of buffer
    
    push    ebx                         ; get index of morse char, will be ASCII code for letter
    call    GetIndex                    ;
    mov     byte ptr [edi], al          ; move letter to our ret buffer
    inc     edi                         ; increase return buffer pointer
    
    lea     ebx, TempBuf                ; get start address of buffer
    inc     esi                         ; increase string pointer
    cmp     byte ptr [esi], 32          ; is next char a space?
    jne     @F                          ; no, get next morse char
    inc     esi                         ; yes, increase string pointer
    mov     byte ptr [edi], 32          ; move space char to return buffer
    inc     edi                         ; increase ret pointer
@@:    
    jmp     NextCode
    
MorseDone:
    mov     eax, RetBuf                 ; move converted buffer pointer to eax for return
    ret
toPlainText endp


COMMENT !
#############################################################
GetIndex - Searches Morse Code lookup table for match

In:     lpszMorseChar = Pointer to buffer with morse code character      
Returns:
        0 for no match
        Index of match = ASCII code of morse code char
############################################################! 
GetIndex proc uses esi edi ebx lpszMorseChar:DWORD
    xor     esi, esi                    ; zero our counter
    mov     edi, offset MorseTable      ; load up lookup table
MorseSearch:
    mov     ebx, [edi + 4 * esi]        ; get char pointer at index in esi
    test    ebx, ebx                    ; if zero - not a valid char
    jz      NotFound                    ;

    invoke  Cmpi, lpszMorseChar, ebx    ; are Lookup table char and MorseChar the same?
    test    eax, eax
    jnz     NotFound

    xchg    esi, eax                    ; yup, put counter value in eax for return
    jmp     SearchDone
    
NotFound:
    inc     esi                         ; increase our counter
    cmp     esi, MorseTableSize         ; are we at end of table?
    jne     MorseSearch                 ; nope, get next lookup pointer
    
MorseNotFound:                          
    xor     eax, eax                    ; not found, return 0

SearchDone:
    ret
GetIndex endp

CenterWindow PROC USES ebx esi edi mainWndHndl:DWORD, targetWndHndl:DWORD    
LOCAL   mainWnd     :RECT
LOCAL   targetWnd   :RECT


        xor     eax, eax
        push    eax
        lea		eax, DWORD PTR [ebp-20h]
        push    eax
        mov     edx, DWORD PTR [ebp+0Ch]
        push    edx
        call    GetWindowRect               

		lea	eax, DWORD PTR [ebp-20h]      
        mov     esi, targetWnd.bottom
        mov     edi, targetWnd.right
        sub     esi, targetWnd.top
        sub     edi, targetWnd.left
        push    esi
        push    edi
        shr     esi, 1
        shr     edi, 1
        lea     eax, DWORD PTR [ebp-10h]
        push    eax
        mov     edx, DWORD PTR [ebp+8]
        push    edx
        call    GetWindowRect               
        
        mov     eax, mainWnd.bottom         
        mov     ecx, mainWnd.right
        sub     eax, mainWnd.top
        sub     ecx, mainWnd.left
        shr     eax, 1
        shr     ecx, 1
        sub     eax, esi
        sub     ecx, edi
        mov     ebx, mainWnd.top
        mov     edx, mainWnd.left
        add     ebx, eax
        add     edx, ecx
        push    ebx
        push    edx
        mov     eax, targetWndHndl
        push    eax
        call    MoveWindow                 
        
        ret
CenterWindow ENDP

SaveToFile proc uses edi esi ebx lpszText:DWORD, lpszMorse:DWORD
local   hSaveFile:DWORD
local   lpWritten:DWORD
local   ofn:OPENFILENAME
local   SavePath[MAX_PATH + 1]:BYTE

    invoke  RtlZeroMemory, addr ofn, sizeof OPENFILENAME
    mov     ofn.lStructSize, sizeof OPENFILENAME
    mov     ofn.hwndOwner, edi
    invoke  GetModuleHandle, NULL
    mov     ofn.hInstance, eax
    mov     ofn.Flags,  OFN_HIDEREADONLY or OFN_EXPLORER 
    mov     ofn.lpstrFilter, offset szDlgFilter
    mov     ofn.lpstrTitle, offset szTitleSave
    lea     esi, SavePath
    mov     ofn.lpstrFile, esi
    mov     ofn.nMaxFile, MAX_PATH + 1
    mov     ofn.lpstrDefExt, offset szDlgExt
    invoke  GetSaveFileName, addr ofn
    invoke  szLen, esi
    .if eax > 0
        ; open the file if it exists, or create new if not exist
        invoke  CreateFile, esi, GENERIC_WRITE, NULL, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
        mov     hSaveFile, eax
        ; set file pointer to end of file to append 
        invoke  SetFilePointer, eax, NULL, NULL, FILE_END
        invoke  szLen, lpszText
        lea     ebx, lpWritten
        invoke  WriteFile, hSaveFile, lpszText, eax, ebx, NULL
        invoke  WriteFile, hSaveFile, offset CRLF, 2, addr lpWritten, NULL
        invoke  szLen, lpszMorse
        invoke  WriteFile, hSaveFile, lpszMorse, eax, ebx, NULL
        invoke  WriteFile, hSaveFile, offset CRLF, 2, addr lpWritten, NULL
        invoke  CloseHandle, hSaveFile
    .endif   
    ret
SaveToFile endp
end MorseCodeTranslator

