INCLUDE Irvine32.inc
includelib winmm.lib
ExitProcess proto, dwExitCode:dword
PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD
.data
    posl BYTE 5
    count BYTE 0
    count1 BYTE -1
    file11 BYTE "C:\Users\Jin\Downloads\Project32_VS2022\Project32_VS2022\button-11.wav",0
    file2 BYTE "gameover.wav",0
    file3 BYTE "menu.wav",0
    file4 BYTE "win.wav",0
    SND_ALIAS    DWORD 00010000h
    leaderboardtxt BYTE "Leaderboard",0
    border1 BYTE "=======================================",0
    border2 BYTE "|",0
    SND_RESOURCE DWORD 00040005h
    SND_FILENAME DWORD 00020000h
    file BYTE "button-14.wav",0
    xcord BYTE 53            ; X-coordinate for cursor
    ycord BYTE 1             ; Y-coordinate for cursor
    welcomeText BYTE "Welcome", 0
    enterNameText BYTE "Enter your name:", 0
    nam BYTE 50 DUP(0)       ; Allocate 50 bytes for the name input buffer
    tempBuffer BYTE 50 DUP(0) 
    clevel byte "level 1",0
    clvl2 byte "level2",0
    clvl3 byte "level3",0
    space BYTE " ", 0
    level1clear byte "  Level 1 cleared!!  ",0
    level2clear byte "  Level 2 cleared!!  ",0
    level3clear byte "  Game cleared!!  ",0
    newline BYTE " ", 0ah, 0dh, 0
    menuText BYTE "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN MENU~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", 0
    nametxt BYTE "Names",0
    Scoretxt BYTE "Scores",0
    playgametext BYTE "1. Play Game", 0
    instructionstext BYTE "2. Instructions", 0
    leaderboardtext BYTE "3. Leaderboard", 0
    ballX BYTE 55              ; Ball's X-coordinate (initial position)
    ballY BYTE 12              ; Ball's Y-coordinate (initial position)
    ballDX BYTE 1              ; Ball's horizontal movement (1 for right)
    ballDY BYTE 1              ; Ball's vertical movement (1 for down)
    gameOverText BYTE "Game Over", 0
    quittext BYTE "4. Quit", 0
    selectedOption BYTE 0    ; Store current menu option
    numOptions BYTE 4        ; Number of menu items (Play Game, Instructions, Leaderboard, Quit)
    key BYTE ?               ; To store user input key
    highlightColor DWORD (14 * 16) ; Yellow on black for selected option
    normalColor DWORD (7 * 16)     ; Light gray on black for unselected options
    gameStart BYTE "Game Started",0
     instruction1 BYTE "~ Use the paddle to bounce the ball and break all the bricks without letting the ball fall off the screen",0
    instruction2 BYTE "~ Move the paddle left and right using arrow keys",0
    instruction3 BYTE "~ Breaking bricks earns points, clear all the bricks to win",0
    colorarray dword 19,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19 
    lives byte 3
    nametext BYTE "Name:",0
    scores DWORD 0
    LivesSign BYTE "|",0
    LivesText BYTE "Lives:",0
    scoresText BYTE "Score:",0       
    quitgameprompt byte "                                               Goodbye Brick breaker champ!",13,10
                    byte "                                             The bricks are safe... for now",13,10
                    byte 0
    powerup BYTE "Powerup granted",0
    hellotext   db '                               ___   ___  _______   ___       ___       ________  ________                              ', 13, 10
            db '                              |\  \ |\  \|\  ___ \ |\  \     |\  \     |\   __  \|\   __  \                             ', 13, 10
            db '                               \ \  \\\  \ \   __/|\ \  \    \ \  \    \ \  \|\  \ \  \|\  \                            ', 13, 10
            db '                                \ \   __  \ \  \_|/_\ \  \    \ \  \    \ \  \\\  \ \  \\\  \                           ', 13, 10
            db '                                 \ \  \ \  \ \  \_|\ \ \  \____\ \  \____\ \  \\\  \ \  \\\  \                          ', 13, 10
            db '                                  \ \__\ \__\ \_______\ \_______\ \_______\ \_______\ \_______\                         ', 13, 10
            db '                                   \|__|\|__|\|_______|\|_______|\|_______|\|_______|\|_______|                         ', 13, 10
            db '                                                                                                                        ', 13, 10
            db 0
     lastposx BYTE ?
     lastposy BYTE ?
     balllastposx BYTE ?
     balllastposy BYTE ?
     numBricks byte 8
     Bricks byte 1,1,1,1,1,1,1,1
     paddlewidth byte 15

    newline2 BYTE 0Dh, 0Ah, 0  ; Carriage return and line feed
    bytesWritten DWORD ? 
    comma BYTE ",", 0  
    filename BYTE "usernames.txt", 0
    buffer BYTE 256 DUP(0)
    buffer3 BYTE 256 DUP(0)          ; Temporary buffer for name
    buffer1 BYTE 256 DUP(0)          ; Temporary buffer for score string
    bytesRead DWORD ?
    filehandle DWORD ?
    leaderboardNames BYTE 200 DUP(0) ; Stores top 10 names (20 bytes each)
    leaderboardScores DWORD 10 DUP(0) ; Stores top 10 scores
    empty_message BYTE "No data in the leaderboard.", 0
    error_message BYTE "Error opening file.", 0
    iisort dd 0
    buffercount dd 0
    parsedsc dd ?
    currenths dd ?
.code

.code

; ---- Clears the screen ----
clearscreen PROC
    mov edx, OFFSET newline  
clear_loop:
    call WriteString
    loop clear_loop
    ret
clearscreen ENDP

; ---- Display Main Menu ----
menu_screen PROC
    mov ecx,50
    call clearscreen          ; Clear the screen before displaying the menu
    mov dl, 52                ; Center X-coordinate for the menu title
    mov dh, 1                 ; Top Y-coordinate
    call Gotoxy
    mov edx, OFFSET menuText
    call WriteString          ; Print "MAIN MENU"

    call CRLF              ; Move to the next line
    call DisplayMenu          ; Display menu items
    ret
menu_screen ENDP

DisplayMenu PROC
    mov eax, (13 * 16)                ; Set text color to black on light magenta
    call SetTextColor
    mov ecx,600
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    mov dl,0               ; Center X-coordinate for the menu title
    mov dh, 1                 ; Top Y-coordinate
    call Gotoxy
    mov eax,13(0*16)
    call SetTextColor
    mov edx, OFFSET menuText
    call WriteString  
    mov cl, [numOptions]             ; Number of menu options
    xor ebx, ebx                     ; Reset option index to 0

display_loop:
    mov dl, 50                       ; X-position for menu items
    mov dh, 3                        ; Starting Y-position for menu items
    add dh, bl                       ; Increment Y-position for each item
    call Gotoxy                      ; Move cursor to the position

    ; Determine the text for the current option
    cmp bl, 0
    je set_playgame
    cmp bl, 2
    je set_instructions
    cmp bl, 4
    je set_leaderboard
    cmp bl, 6
    je set_quit

set_playgame:
    mov edx, offset playgametext
    jmp print_text

set_instructions:
   mov edx, offset instructionstext
    jmp print_text

set_leaderboard:
   mov edx, offset leaderboardtext
    jmp print_text

set_quit:
    lea edx, quittext
    jmp print_text

print_text:
    mov eax,12(14*16)
    call SetTextColor
    call WriteString                 ; Display the menu item text
    inc bl 
    inc bl
    loop display_loop                ; Repeat for all menu items
    ret
DisplayMenu ENDP



inputLoop1 PROC
    call menu_screen          ; Initialize the menu screen once

inputLoop:
    mov ecx,50
    call clearscreen
    INVOKE PlaySound, OFFSET file3, NULL, 2001h
    call DisplayMenu          ; Display only the menu options (no screen clearing)
    call ReadChar             ; Read a key from the user
    mov key, al               ; Store the key in 'key'
    INVOKE PlaySound, NULL, NULL, 40h
    INVOKE PlaySound, OFFSET file11, NULL, 2001h
    cmp key, '1'              ; Check if the user pressed '1'
    je playGame1
    cmp key, '2'              ; Check if the user pressed '2'
    je instructions1
    cmp key, '3'              ; Check if the user pressed '3'
    je leaderboard12
    cmp key, '4'              ; Check if the user pressed '4'
    je quitProgram1

    jmp inputLoop

playGame1:
    mov al,0
    mov count,0
    mov ecx,1000
    mov edx,offset Space
    call ClearScreen
    mov eax,0(13*16)
    call SetTextColor
    mov ecx,8
    mov esi,offset Bricks
    loopballs:
        mov bl,1
        mov[esi+ecx],bl
        loop loopballs
    mov paddleWidth,8
    mov ballX,54
    mov ballY,10
    mov eax,3
    mov lives,al
    call playGame
    cmp al,27
    je label1
    cmp lives,0
    jne nextlev
    jmp label1
nextlev:
    mov al,0
    mov count,0
    call PlayGame2
    cmp al,27
    je label1
    cmp lives,0
    jne nextlev1
    jmp label1
nextlev1:
    mov al,0
    mov count,0
    call PlayGame3
    cmp al,27
    je label1
    jmp inputLoop
label1:
    call CreateAndWriteFile
    jmp inputloop

instructions1:
    call instructions
    jmp inputLoop

leaderboard12:
    call leaderboard
    jmp inputLoop

quitProgram1:
    call quitprogram

inputLoop1 ENDP
leaderboard1 PROC
    mov ecx,80
    call clearscreen
    mov dh,1
    mov dl,50
    call Gotoxy
    mov edx,offset leaderboardtxt
    call WriteString
    mov dh,3
    mov dl,2
    call Gotoxy
    mov edx,offset nametxt
    call WriteString
    mov dh,3 
    mov dl,50
    call Gotoxy
    mov edx, offset scoretxt
    call WriteString
leaderboardloop:

    ; Initialize leaderboard arrays
    mov ecx, SIZEOF leaderboardNames
    lea edi, leaderboardNames
    xor eax, eax
    rep stosb                       ; Clear names array

    mov ecx, 10
    lea edi, leaderboardScores
    xor eax, eax
    rep stosd                       ; Clear scores array

    ; Open the file for reading
    invoke CreateFile, OFFSET filename, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov filehandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je error_exit

    ; Read file content
    invoke ReadFile, filehandle, OFFSET buffer, SIZEOF buffer, OFFSET bytesRead, 0
    cmp bytesRead, 0                ; Check if file is empty
    je empty_file

    ; Parse file content into temporary arrays
    
parse_line:
    ; Parse name
    mov eax, buffercount
    lea esi, [buffer +eax]                ; Start of file buffer
    lea edi, buffer3                ; Temporary buffer for name
    xor ecx, ecx                    ; Name index
parse_name:
    mov al, [esi]
    inc esi
    inc buffercount
    cmp al, ','                     ; Check for delimiter
    je parse_score
    cmp al, 0Dh                     ; End of line
    je end_of_line
    mov [edi + ecx], al
    inc ecx
    jmp parse_name

parse_score:
    inc buffercount
    mov byte ptr [edi + ecx], 0     ; Null-terminate the name
    mov eax, 0
    lnull:
    inc ecx
    inc eax
    mov byte ptr [edi + ecx], 0     ; Null-terminate the name
    cmp eax, 20
    jne lnull

    lea edi, buffer1                ; Temporary buffer for score
    xor ecx, ecx                    ; Score index
parse_score_loop:
    mov al, [esi]
    inc esi
    inc buffercount
    cmp al, 0Dh                     ; End of line
    je end_of_line
    mov [edi + ecx], al
    inc ecx
    jmp parse_score_loop

end_of_line:
    mov byte ptr [edi + ecx], 0     ; Null-terminate score string
    mov edx, OFFSET buffer1
    call StrToInt
    mov ecx, eax                    ; Parsed score
    mov parsedsc, eax
    ; Check if name already exists in leaderboard
    lea edx, leaderboardNames
    mov edi, offset buffer3
    xor ebx, ebx                    ; Reset index to 0
check_existing:
    cmp ebx, 10                     ; Compare against 10 entries
    jge no_match                    ; If not found, proceed to normal logic
    mov edi, offset buffer3
    lea esi, [edx ]       ; Point to current name in leaderboard
    mov ecx, 20
    repe cmpsb                      ; Compare name with leaderboard entry
    je name_found                   ; If name matches, jump to update logic
    add edx, 20                     ; Move to next name
    inc ebx                         ; Increment index
    jmp check_existing

no_match:
    ; Compare with the 10th entry
    lea edi, leaderboardScores
    mov eax, [edi + 36]             ; 10th score is at offset 36 (4 bytes * 9)
    cmp parsedsc, eax
    jle parse_next_line             ; Skip if score is less than or equal to the 10th entry

    ; Replace the 10th entry
    mov eax, parsedsc
    mov [edi + 36], eax             ; Update score
    lea esi, buffer3
    lea edi, leaderboardNames
    lea edi, [edi + 180]            ; 10th name starts at offset 180
    mov ecx, 20
    rep movsb                       ; Copy name

    ; Sort the leaderboard
    call SortLeaderboard
    jmp parse_next_line

name_found:
    ; Update score if the new score is greater
    lea edi, leaderboardScores
    mov eax, [edi + ebx * 4]        ; Existing score
    cmp parsedsc, eax
    jle parse_next_line             ; If new score is not higher, skip
    mov eax, parsedsc
    mov [edi + ebx * 4], eax        ; Update score
    call SortLeaderboard            ; Sort the leaderboard after update
    jmp parse_next_line

parse_next_line:
    mov eax, buffercount
    lea esi, [buffer + eax]
    cmp byte ptr [esi], 0           ; Check for end of buffer
    jnz parse_line

    ; Display top 10 scores
    mov ecx, 10                     ; Display limit
    xor esi, esi                    ; Start index
display_loop:
    cmp esi, ecx
    jge done_display                ; Exit if all 10 entries have been processed

    ; Check if score is greater than zero
    lea edi, leaderboardScores
    mov eax, [edi + esi * 4]
    cmp eax, 0
    jle skip_entry

    ; Display name
    mov dh,posl
    mov dl,3
    call Gotoxy
    lea edi, leaderboardNames
    mov eax, esi
    imul eax, 20
    lea edx, [edi + eax]
    call WriteString
    mov edx,offset space
    call WriteString

    ; Display score
    mov dh,posl
    mov dl,51
    call Gotoxy
    inc posl
    lea edx, leaderboardScores
    mov eax, [edx + esi * 4]
    call WriteDec
    mov edx,offset space
    call WriteString
    call Crlf

skip_entry:
    inc esi
    jmp display_loop

done_display:
    invoke CloseHandle, filehandle
    call ReadChar
    cmp al, 27
    jne leaderboardloop
    ret

empty_file:
    mov edx, OFFSET empty_message
    call WriteString
    invoke CloseHandle, filehandle
    ret

error_exit:
    mov edx, OFFSET error_message
    call WriteString
    invoke ExitProcess, 1
    ret

leaderboard1 ENDP


SortLeaderboard PROC
    push esi
    push edi
    push ebx
    push ecx

    mov iisort, 0                      ; Outer loop index
sort_outer:
    mov ecx, 9                      ; Compare up to the second-to-last entry
    sub ecx, iisort
    jle done_sorting

    xor ebx, ebx                    ; Inner loop index
sort_inner:
    lea edx, leaderboardScores
    mov eax, [edx + ebx * 4]        ; Current score
    mov edi, [edx + ebx * 4 + 4]    ; Next score
    cmp eax, edi
    jge no_swap                     ; If current >= next, no need to swap

    ; Swap scores
    mov [edx + ebx * 4], edi
    mov [edx + ebx * 4 + 4], eax

    ; Swap names
    lea esi, leaderboardNames
    mov eax, ebx
    imul eax, 20
    lea esi, [esi + eax]
    lea edi, buffer3
    mov ecx, 20
    rep movsb                       ; Copy current name to buffer3

    lea esi, leaderboardNames
    mov eax, ebx
    
    imul eax, 20
    lea edi, [leaderboardNames + eax]
    mov eax, ebx
    add eax, 1
    imul eax, 20
    lea esi, [esi + eax]
    mov ecx, 20
    rep movsb                       ; Copy next name to current position

    lea esi, buffer3
    mov eax, ebx
    imul eax, 20
    add eax, 20
    lea edi, [leaderboardNames + eax]
    mov ecx, 20
    rep movsb                       ; Copy buffer3 to next name position

no_swap:
    inc ebx
    cmp ebx, ecx
    jl sort_inner

    inc iisort
    jmp sort_outer

done_sorting:
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret
SortLeaderboard ENDP

StrToInt PROC
    xor eax, eax
    xor ebx, ebx
next_digit:
    mov bl, [edx]
    test bl, bl
    je done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc edx
    jmp next_digit
done:
    ret
StrToInt ENDP
; Conversion procedure: converts the number in EAX to a string in buffer1
NumToStr PROC
    mov eax, scores        ; Load the value of the score into EAX
    mov ecx, 0              ; Initialize digit counter to 0

CountDigits:
    cmp eax, 0              ; Check if the number is 0
    je Done                 ; If 0, we're done
    inc ecx                 ; Increment digit counter
    mov edx, 0              ; Clear EDX for division
    mov ebx, 10             ; Divisor is 10
    div ebx                 ; EAX = EAX / 10, remainder in EDX
    jmp CountDigits         ; Repeat the process

Done:
    
    
    
    lea eax, buffer1            ; Load base address of buffer1 into EAX
    add eax, ecx       ; Add the value of ecx
    mov edi, eax                ; Move the result into EDI
    mov eax, scores
    mov ecx, 0                     ; Initialize digit counter
    mov byte ptr [edi], 0          ; Null-terminate the buffer

    cmp eax, 0
    jne ConvertLoop                ; If number is non-zero, convert it

    ; Special case for 0
    mov byte ptr [edi-1], '0'      ; Write '0'
    dec edi                        ; Adjust EDI
    inc ecx                        ; Length is 1
    jmp FinishConversion

ConvertLoop:
    xor edx, edx                   ; Clear remainder register
    mov ebx, 10                    ; Divisor
    div ebx                        ; Divide EAX by 10 (EAX = EAX / 10, EDX = remainder)
    add edx, '0'                   ; Convert remainder to ASCII
    dec edi                        ; Move pointer backward
    mov [edi], dl                  ; Store ASCII character in buffer
    inc ecx                        ; Increment digit counter
    test eax, eax                  ; Check if EAX is 0
    jnz ConvertLoop                ; Repeat if EAX is not 0

FinishConversion:
    mov eax, edi
    ret
NumToStr ENDP

CreateAndWriteFile PROC
    ; Open or create the file
    mov edx, offset filename
    invoke CreateFile, edx, GENERIC_WRITE, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov fileHandle, eax             ; Save the file handle
    cmp eax, INVALID_HANDLE_VALUE
    je error_exit                   ; Exit if file opening fails

    ; Move the file pointer to the end for appending
    invoke SetFilePointer, fileHandle, 0, 0, FILE_END

    lea esi, nam                    ; Point to the name buffer
lea edi, tempBuffer             ; Point to a temporary buffer
copy_nam:
    mov al, [esi]               ; Load the next character
    test al, al                 ; Check for null terminator
    jz add_spaces               ; Stop at null terminator
    mov [edi], al               ; Copy character
    inc esi
    inc edi
    jmp copy_nam

; 2. Add 10 spaces after the `nam` string in `tempBuffer`.
add_spaces:
    mov ecx, 5                 ; Number of spaces to add
add_space_loop:
    mov byte ptr [edi], ' '     ; Add space
    inc edi
    loop add_space_loop

; 3. Append `clevel` string to `tempBuffer`.
lea esi, clevel                 ; Point to `clevel` string
append_clevel:
    mov al, [esi]               ; Load the next character
    test al, al                 ; Check for null terminator
    jz calculate_length         ; Stop at null terminator
    mov [edi], al               ; Copy character
    inc esi
    inc edi
    jmp append_clevel

; 4. Calculate total length of the modified string.
calculate_length:
    lea esi, tempBuffer         ; Point to the start of the modified buffer
    xor ecx, ecx                ; Reset length counter
find_total_null:
    mov al, [esi + ecx]         ; Load the next character
    test al, al                 ; Check for null terminator
    jz write_name          ; Stop at null terminator
    inc ecx                     ; Increment counter
    jmp find_total_null

; 5. Write the modified buffer to the file.
write_name:
    invoke WriteFile, fileHandle, OFFSET tempBuffer, ecx, OFFSET bytesWritten, 0

    ; Write a comma separator
    mov edx, OFFSET comma           ; Prepare to write a comma
    invoke WriteFile, fileHandle, edx, 1, OFFSET bytesWritten, 0

    ; Convert score to a string
    mov eax, scores                  ; Load the score into EAX
    call NumToStr                   ; Convert score to string (result in buffer1)

    ; Write the score to the file
    lea edx, buffer1
    invoke WriteFile, fileHandle, edx, ecx, OFFSET bytesWritten, 0

    ; Write a newline to the file
    mov edx, OFFSET newline2        ; Prepare to write a newline
    invoke WriteFile, fileHandle, edx, 2, OFFSET bytesWritten, 0

    ; Close the file
    invoke CloseHandle, fileHandle
    ret

error_exit:
    ; Handle error (optional)
    invoke ExitProcess, 1
    ret
CreateAndWriteFile ENDP
DrawPaddle PROC
    ; Erase the previous paddle
    mov ycord,ch
    mov xcord,bh
    mov bh,23
    mov bl,2
    mov eax, 13(13 * 16)        ; Black on black for erasing
    call SetTextColor
    mov ecx,109
erasePaddle:
    push ecx
    call Gotoxy
    mov edx, OFFSET space
    call WriteString         ; Write a space to "erase" the paddle
    pop ecx
    mov dl,bl
    mov dh,bh
    inc bl                   ; Move to the next column
    loop erasePaddle

    ; Draw the new paddle
    mov dh, ch               ; Paddle Y-coordinate
    mov dl, bh               ; Paddle X-coordinate
    mov cl, ah               ; Paddle width
    mov eax, (12 * 16)       ; Bright white on black
    call SetTextColor
    
    mov dh, ycord               ; Paddle Y-coordinate
    mov dl, xcord               ; Previous paddle X-coordinate
    mov cl, paddleWidth                   ; Paddle width
drawPaddle1:
    push cx
    call Gotoxy
    mov edx, OFFSET space
    call WriteString         ; Write spaces to represent the paddle
    pop cx
    inc dl                   ; Move to the next column
    loop drawPaddle1

    ret
DrawPaddle ENDP


DrawBorder PROC
    mov eax, (8 * 16)        ; Gray on black
    call SetTextColor

    ; Draw top and bottom borders
    mov cx, 110               ; Width of the screen
    mov dh, 0; Top border
drawTop:
    MOV DH,0
    mov dl, cl
    call Gotoxy
    mov edx, OFFSET space
    call WriteString
    loop drawTop

    mov dh, 28               ; Bottom border
    mov cx, 110
drawBottom:
    MOV DH,28
    mov dl, cl
    call Gotoxy
    mov edx, OFFSET space
    call WriteString
    loop drawBottom

    ; Draw left and right borders
    mov cx, 28
    mov dl, 1                ; Left border
drawLeft:
    MOV DL,1
    mov dh, cl
    call Gotoxy
    mov edx, OFFSET space
    call WriteString
    loop drawLeft

    mov dl,109              ; Right border
    mov cx, 28
drawRight:
    MOV DL,110
    mov dh, cl
    call Gotoxy
    mov edx, OFFSET space
    call WriteString
    loop drawRight

    ret
DrawBorder ENDP

GenerateRandomNumber PROC
    ; Generate a pseudo-random number
    rdtsc                     
    ret
GenerateRandomNumber ENDP

checknumBricks PROC

    mov ecx,0
    mov esi,offset Bricks
    loop1:
        cmp ecx,4
        je skipcheck
        cmp ecx, 1
        je skipcheck
        mov al,byte ptr [esi+ecx]
        cmp al,0
        jne bricksleft
        inc ecx
        cmp ecx,7
        je noBricks
        jmp loop1
skipcheck:
    inc ecx
    jmp loop1
bricksleft:
    mov edx,0
    ret
noBricks:
    mov edx,1
    ret
checknumBricks ENDP

RemoveRandomBricks PROC
    mov ecx, 5               ; Remove up to 5 bricks
    lea esi, Bricks          ; Point to the Bricks array
removeLoop:
    xor eax,eax
    call checknumBricks
    cmp edx,1
    je Done
    mov al, numBricks
    call GenerateRandomNumber ; Get random index in EAX
    mov cl, numBricks
    xor edx, edx
    div ecx                 ; Random index between 0 and numBricks-1
    mov ebx, offset Bricks
    add ebx, edx             ; Point to random brick
    
    cmp dl, 1
    je skipRemoval
    cmp dl,7
    je skipRemoval
    cmp dl, 4                ; Skip special brick
    je skipRemoval
    mov al, byte ptr [ebx]
    cmp al, 0                ; Skip if already destroyed
    je skipRemoval
    mov byte ptr [ebx], 0    ; Destroy the brick
    dec ecx                  ; Decrement removal count

skipRemoval:
    cmp ecx, 0
    jne removeLoop           ; Repeat until 5 bricks are removed or no more left
Done:
    ret
RemoveRandomBricks ENDP


checkBricksCollision PROC
    ; Ball position: (ballX, ballY)
    mov al, ballX              ; Load ball X-coordinate
    mov ah, ballY              ; Load ball Y-coordinate
    lea esi, Bricks            ; Point to the Bricks array
    mov cl, numBricks          ; Number of bricks to check
    mov bl, 5                  ; Initial X-coordinate of the first brick
    mov bh, 5                  ; Initial Y-coordinate of the first brick

brickCheckLoop:
    mov dl, [esi]              ; Load brick status (1 = active, 0 = destroyed)
    test dl, dl
    je skipBrick               ; Skip if the brick is destroyed

    ; Calculate boundaries of the current brick
    mov dl, bl                 ; Left boundary
    cmp al, dl
    jb skipBrick               ; Ball is to the left
    add dl, 20                 ; Right boundary
    cmp al, dl
    ja skipBrick               ; Ball is to the right

    mov dh, bh                 ; Top boundary
    cmp ah, dh
    jb skipBrick               ; Ball is above
    add dh, 2                  ; Bottom boundary
    cmp ah, dh
    ja skipBrick               ; Ball is below

    ; Collision detected
    mov al, byte ptr [esi]
    cmp al,5
    je disappearbricks
    dec al
    mov byte ptr [esi], al      ; Mark brick as destroyed
    mov ecx,30
    cmp al,0
    je addscr
    call ReverseBallDirection  ; Reverse ball's direction
    call drawBricks
    INVOKE PlaySound, OFFSET file, NULL, SND_FILENAME
    
    ret                        ; Exit after handling the collision
disappearbricks:
    mov al,0
    mov [esi],al
    call removerandombricks
    cmp al,0
    mov ecx,150
    je addscr
    call ReverseBallDirection  
    call drawBricks     
skipBrick:
    ; Move to the next brick
    add bl, 27                 ; Move X-coordinate by brick width + spacing
    dec cl
    cmp cl, 4                  ; Check if the row ends after 4 bricks
    jnz checkNextRow
    mov bl, 5                  ; Reset X-coordinate
    add bh, 3                  ; Move to the next row

checkNextRow:
    inc esi                    ; Next brick in array
    cmp cl, 0
    jne brickCheckLoop
    ret
addscr:
    add scores,ecx
    call ReverseBallDirection  ; Reverse ball's direction
    call drawBricks
    INVOKE PlaySound, OFFSET file, NULL, 2001h
    add count,1
    cmp count,4
    je givepowerup
    ret 
givepowerup:
    mov al,5
    add paddlewidth,5
    mov count1,80
    mov dh,26
    mov dl,52
    call Gotoxy
    mov eax, 0(13*16)
    call setTextColor
    mov edx,offset powerup
    call WriteString
    ret
checkBricksCollision ENDP



ReverseBallDirection PROC
    ; Reverse the ball's direction based on collision
    ; (Assumes ballDX and ballDY hold the ball's current direction)
    neg ballDY               ; Reverse vertical direction
    ret
ReverseBallDirection ENDP


 DrawBricks PROC
    mov xcord, 5                 ; Initial X-coordinate
    mov ycord, 5                 ; Initial Y-coordinate
    mov dh, ycord                ; Starting Y-coordinate
    mov dl, xcord                ; Starting X-coordinate
    mov cl, numBricks            ; Total number of bricks to draw
    lea esi, Bricks              ; Point to the Bricks array
    lea edi, colorarray          ; Point to the color array

drawBrickLoop:
    mov al, [esi]                ; Load the current brick's status
    cmp al, 0                    ; Check if the brick exists
    je skipBrick                ; Skip if brick is destroyed (value is not 1)
    mov eax, [edi]               ; Load color from the color array
    mov ebx,16
    mul ebx
    call SetTextColor            ; Apply the color
    add edi, 4
    mov al, [esi]                ; Load the current brick's status
    cmp al, 0
    cmp al,2
    je setcolor
    cmp al,3 
    je setcolor1
    cmp al,5
    je drawspecial
    cmp al,3
    jg setfixed
    jmp drawb
drawspecial:
    mov eax, 3(3*16)
    call setTextColor
    jmp drawb
setcolor1:
    mov eax, 2(2*16)
    call setTextColor
    jmp drawb
setfixed:
    mov eax,0(0*16)
    call setTextColor
    jmp drawb
setcolor:
    mov eax,1 (1*16)
    call setTextColor
    jmp drawb
drawb:
    ; Draw the brick
    mov dh, ycord                ; Current Y-coordinate
    mov dl, xcord                ; Current X-coordinate
    call Gotoxy                  ; Move to the position
    mov ebx, 20                  ; Brick width (20 characters)
drawBrickRow:
    mov edx, OFFSET space        ; Character to represent the brick
    call WriteString             ; Write a single character of the brick
    dec ebx
    cmp ebx,0
    jne drawBrickRow            ; Repeat for the width of the brick
    add xcord,27
    jmp Checkrow
skipBrick:
    ; Update the X-coordinate for the next brick
    add edi,4
    mov dl,xcord
    mov dh,ycord
    call Gotoxy
    mov bl,27
    mov eax, 13(13*16)
    call setTextColor
    mov edx,offset space
    drawsp:
        call WriteString
        dec bl
        cmp bl,0
        jne drawsp
    add xcord, 27                ; Brick width + spacing (20 + 7)
Checkrow:
    ; Check if we need to move to the next row
    cmp cl, 5                    ; Check if it's the fourth brick in the row
    jne checkEnd                 ; If not, continue to the next brick
    mov xcord, 5                 ; Reset X-coordinate for the next row
    add ycord, 3                 ; Move down by 3 rows
    mov dh, ycord                ; Update Y-coordinate

checkEnd:
    
    inc esi                      ; Move to the next brick in the array
    dec cl                       ; Decrement the brick counter
    cmp cl, 0                    ; Check if all bricks are processed
    jne drawBrickLoop            ; Continue if there are more bricks

    ret
DrawBricks ENDP

MoveBall PROC
    ; Erase the ball at the previous position
    mov eax, 13(13*16)
    call setTextColor
    mov dl, ballX
    mov dh, ballY
    call Gotoxy                 ; Move cursor to previous ball position
    mov edx, OFFSET space       ; Erase the ball by writing a space
    call WriteString

    ; Save the current position as last position
    xor ebx,ebx
    mov bl,ballX
    mov bh,ballY
    mov balllastposx, bl
    mov balllastposy, bh

    ; Update ball position
    mov al, ballDX
    add ballX, al
    mov al, ballDY
    add ballY, al

    ; Draw the ball at the new position
    mov dl, ballX
    mov dh, ballY
    call Gotoxy
    mov eax, (9 * 16)          ; Ball color (Yellow on black)
    call SetTextColor
    mov edx, OFFSET space       ; Draw the ball (a space with color)
    call WriteString

    ; Check for collision with the left and right borders
    cmp ballX, 3               ; Ball hits left border
    jl BounceBallLeft
    cmp ballX, 108             ; Ball hits right border
    jg BounceBallRight

    ; Check for collision with the top border
    cmp ballY, 3
    jl BounceBallDown

    ; Check for collision with the bottom border (lose a life)
    cmp ballY, 28
    jg BallFalls

    ; Check for collision with the paddle
    mov al, ballY
    cmp al, lastposy           ; Assuming paddleY holds paddle's Y-coordinate
    jne NoPaddleCollision
    mov al, ballX
    cmp al, lastposx            ; Assuming paddleX is paddle's starting X-coordinate
    jb NoPaddleCollision
    mov bl,lastposx
    add bl,paddlewidth
    cmp al, bl      ; Assuming paddleEndX is paddle's ending X-coordinate
    ja NoPaddleCollision
    call BounceBallUp          ; Reverse direction upon collision with the paddle

NoPaddleCollision:
    ret

BounceBallLeft:
    neg ballDX                 ; Reverse horizontal direction
    ret

BounceBallRight:
    neg ballDX                 ; Reverse horizontal direction
    ret

BounceBallDown:
    neg ballDY                 ; Reverse vertical direction (bounce upwards)
    ret

BounceBallUp:
    neg ballDY                 ; Reverse vertical direction (bounce downwards)
    ret

BallFalls:
    ; Ball falls below the paddle, decrement lives
    dec lives
    cmp lives, 0
    je GameOver                ; Jump to GameOver if no lives remain
    call ResetBall             ; Reset ball position and continue
    ret
MoveBall ENDP
ResetBall PROC
    ; Reset the ball to its starting position
    mov ballX, 55
    mov ballY, 12
    mov ballDX, 1
    mov ballDY, 1
    ret
ResetBall ENDP

GameOver PROC
    mov ecx,60
    call clearscreen
    INVOKE PlaySound, OFFSET file2, NULL, 2001h
    mov eax, (13 * 16)                ; Set text color to black on light magenta
    call SetTextColor
    mov ecx,600
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    ; Handle game over logic
    mov eax, 13(13*16)
    call setTextColor
    call CreateAndWriteFile
    mov eax,12(11*16)
    call SetTextColor
    mov dh,14
    mov dl,52
    call Gotoxy
    mov edx, OFFSET gameOverText
    call WriteString
    mov lives,3
    call ReadChar
    cmp al,13
    je InputLoop1
    ret
GameOver ENDP


DrawBall PROC
    mov dl, ballX
    mov dh, ballY
    mov eax, (7 * 16)         ; White on black text color for ball
    call SetTextColor
    call Gotoxy
    mov edx, OFFSET space
    call WriteString
    ret
DrawBall ENDP

movePaddle PROC
    mov  eax,80        ; sleep, to allow OS to time slice
    call Delay 
    call readkey
    cmp al, 'a'              ; Check if user pressed 'a' to move left
    je MovePaddleLeft
    cmp al, 'd'              ; Check if user pressed 'd' to move right
    je MovePaddleRight
    cmp al, 27               ; Escape key to quit
    jmp EndGame
MovePaddleLeft:
    mov bh,lastposx
    cmp bh, 2                ; Prevent going off the left border
    jle Endgame
    dec bh                   ; Move paddle left
    dec bh
    dec bh
    dec bh
    dec lastposx
    dec lastposx
    dec lastposx
    dec lastposx
    mov ch,lastposy
    call DrawPaddle          ; Redraw the paddle
    jmp Endgame

MovePaddleRight:
    mov bh,lastposx
    mov al,109
    sub al,paddlewidth
    cmp bh, al             ; Prevent going off the right border (110 - paddle width)
    jge Endgame
    inc bh                   ; Move paddle right
    inc bh
    inc bh
    inc bh
    inc lastposx
    inc lastposx
    inc lastposx
    inc lastposx
    mov ch,lastposy
    call DrawPaddle          ; Redraw the paddle
    jmp Endgame

EndGame:
    ret

movePaddle ENDP

CheckWinCondition PROC
    mov edi,offset Bricks
    xor ecx,ecx
    mov cl,numBricks
    loopwin:
        mov bl,1
        cmp [edi+ecx],bl
        je changecond
        mov bl,2
        cmp [edi+ecx],bl
        je changecond
        mov bl,3
        cmp [edi+ecx],bl
        je changecond
        dec cl
        cmp cl,0
        jge loopwin
        jmp done
changecond:
    mov edx,1
done: 
    ret
CheckWinCondition ENDP

winScreen PROC
    mov ecx,80
    call clearscreen
    INVOKE PlaySound, OFFSET file4, NULL, 2001h
    mov ecx,600
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    mov dh,13
    mov dl,50
    call Gotoxy
    mov eax, 13 (0*16)
    call setTextColor
    mov edx,offset level1clear
    call WriteString
    xor eax,eax
    checkchar:
    call ReadChar
    cmp al,13
    je done
    jmp checkchar
    done:
    mov ecx,30
    call clearscreen
    mov eax, 0(13*16)
    call SetTextColor
    mov edx,offset space
    ret
winScreen ENDP

winScreen2 PROC
    mov ecx,80
    call clearscreen
    INVOKE PlaySound, OFFSET file4, NULL, 2001h
    mov ecx,600
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    mov dh,13
    mov dl,50
    call Gotoxy
    mov eax, 13 (0*16)
    call setTextColor
    mov edx,offset level2clear
    call WriteString
    xor eax,eax
    checkchar:
    call ReadChar
    cmp al,13
    je done
    jmp checkchar
    done:
    mov ecx,30
    call clearscreen
    mov eax, 0(13*16)
    call SetTextColor
    ret
winScreen2 ENDP

winScreen3 PROC
    mov ecx,80
    call clearscreen
    INVOKE PlaySound, OFFSET file4, NULL, 2001h
    mov ecx,600
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    mov dh,15
    mov dl,50
    call Gotoxy
    mov eax,13 (0*16)
    call setTextColor
    mov edx,offset level3clear
    call WriteString
    xor eax,eax
    checkchar:
    call ReadChar
    cmp al,13
    je done
    jmp checkchar
    done:
    mov ecx,30
    call clearscreen
    
    mov eax, 0(13*16)
    call SetTextColor
    ret
winscreen3 ENDP

PlayGame3 PROC
    lea si, clvl3            
    lea di, clevel           
    mov cx, lengthof clevel         
    cld                      
    rep movsb
    mov ecx, 30
    call clearscreen
    mov paddleWidth,8
    ; Set up the border
    call DrawBorder          ; Draw a gray border around the game area

    ; Initialize paddle position
    mov ah, 7                ; Paddle width (7 spaces)
    mov bh, 50               ; Paddle X-coordinate (centered)
    mov lastposx,bh
    mov ch, 23               ; Paddle Y-coordinate (bottom row)
    mov lastposy,ch
    mov ballX,28
    mov ballY,8
    mov ecx,8
    mov bl,3
    mov esi,offset Bricks
    loopballs:
        mov [esi+ecx],bl
        loop loopballs
    mov al,126
    mov [esi+1],al
    mov[esi+7],al
    mov al,5
    mov[esi+4],al
    mov [esi],bl
    mov paddlewidth,10
    call DrawBricks
    call DrawPaddle
    gameLoop:
    call DrawBorder
    mov eax, (13 * 16)       ; Text color for UI
    call SetTextColor
    cmp lives,0
    je EndGame
    mov dh,2
    mov dl,8
    call Gotoxy
    mov edx,offset nameText
    call writeString
    mov edx,offset nam
    call WriteString
    mov dh, 2
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET scoresText
    call WriteString
    mov eax, scores
    call WriteDec

    mov dh, 2
    mov dl, 95
    call Gotoxy
    mov edx, OFFSET LivesText
    call WriteString
    mov edx,offset LivesSign
    xor ecx,ecx
    mov cl,lives
    Livesloop:
        call WriteString
        loop Livesloop
    mov eax,13(13*16)
    call settextcolor
    mov edx,offset space 
    call writestring
    call writestring
    call writestring
    ; Read user input for paddle control
    call movePaddle
    ; Game logic (expandable with ball mechanics)
    call DrawBall
    call MoveBall
    call checkBricksCollision
    mov edx,0
    call CheckWinCondition
    cmp edx,0
    je win
    mov eax,25
    call Delay 
    call readkey
    cmp al,27
    je EndGame
    cmp al,32
    je wait1
    dec count1
    cmp count1,0
    je decreasepaddlewidth
    cmp count1,-128
    je switchvalue
    jmp gameLoop
EndGame:
    ret
switchvalue:
    mov count1,-1
    jmp gameloop
decreasepaddlewidth:
    sub paddlewidth,5
    mov ecx,20
    mov dh,26
    mov dl,50
    call gotoxy
    mov eax, 13(13*16)
    call settextcolor
    mov ecx,20
    mov edx,offset space
    loop1:
    call WriteString
    loop loop1
    jmp gameLoop
win: 
    call winScreen3
    call CreateAndWriteFile
    ret
wait1:
    call readchar
    cmp al,13
    je gameloop
    jmp wait1
PlayGame3 ENDP

PlayGame2 PROC
     lea si, clvl2            
    lea di, clevel           
    mov cx, lengthof clevel         
    cld                      
    rep movsb
    mov ecx,600
    mov edx,offset space
    call clearscreen

    mov ballX,56
    mov ballY,8
    mov ecx,8
    mov bl,2
    mov esi,offset Bricks
    loopballs:
        mov [esi+ecx],bl
        loop loopballs
    mov [esi],bl
    mov paddlewidth,10
    call DrawBricks
    call DrawPaddle
    gameLoop:
    call DrawBorder
    mov eax, (13 * 16)       ; Text color for UI
    call SetTextColor
    cmp lives,0
    je EndGame
    mov dh,2
    mov dl,8
    call Gotoxy
    mov edx,offset nameText
    call writeString
    mov edx,offset nam
    call WriteString
    mov dh, 2
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET scoresText
    call WriteString
    mov eax, scores
    call WriteDec

    mov dh, 2
    mov dl, 95
    call Gotoxy
    mov edx, OFFSET LivesText
    call WriteString
    mov edx,offset LivesSign
    xor ecx,ecx
    mov cl,lives
    Livesloop:
        call WriteString
        loop Livesloop
    mov eax,13(13*16)
    call settextcolor
    mov edx,offset space 
    call writestring
    call writestring
    call writestring
    ; Read user input for paddle control
    call movePaddle
    ; Game logic (expandable with ball mechanics)
    call DrawBall
    call MoveBall
    call checkBricksCollision
    mov edx,0
    call CheckWinCondition
    cmp edx,0
    je win
    mov eax,50
    call Delay
    call readkey
    cmp al,27
    je EndGame
    cmp al,32
    je wait1
    dec count1
    cmp count1,0
    je decreasepaddlewidth
   cmp count1,-128
    je switchvalue
    jmp gameLoop
EndGame:
    ret
switchvalue:
    mov count1,-1
    jmp gameloop
decreasepaddlewidth:
    sub paddlewidth,5
    mov dh,26
    mov dl,50
    call gotoxy
    mov ecx,20
    mov eax, 13(13*16)
    call settextcolor
    mov edx,offset space 
    loop1:
    call WriteString
    loop loop1
    jmp gameLoop
win: 
    call winScreen2
    ret
wait1:
    call ReadChar 
    cmp al,13
    je gameLoop
    jmp wait1
PlayGame2 ENDP
playGame PROC
    ; Clear the screen for the game area
    mov ecx, 30
    call clearscreen
    mov paddleWidth,15
    ; Set up the border
    call DrawBorder          ; Draw a gray border around the game area

    ; Initialize paddle position
    mov ah, 7                ; Paddle width (7 spaces)
    mov bh, 50               ; Paddle X-coordinate (centered)
    mov lastposx,bh
    mov ch, 23               ; Paddle Y-coordinate (bottom row)
    mov lastposy,ch
    ; Draw initial paddle
    call DrawPaddle

    ; Draw bricks
    call DrawBricks

gameLoop:
    call DrawBorder
    mov eax, (13 * 16)       ; Text color for UI
    call SetTextColor
    cmp lives,0
    je EndGame
    mov dh,2
    mov dl,8
    call Gotoxy
    mov edx,offset nameText
    call writeString
    mov edx,offset nam
    call WriteString
    mov dh, 2
    mov dl, 50
    call Gotoxy
    mov edx, OFFSET scoresText
    call WriteString
    mov eax, scores
    call WriteDec

    mov dh, 2
    mov dl, 95
    call Gotoxy
    mov edx, OFFSET LivesText
    call WriteString
    mov edx,offset LivesSign
    xor ecx,ecx
    mov cl,lives
    Livesloop:
        call WriteString
        loop Livesloop
    mov eax,13(13*16)
    mov edx,offset space
    call WriteString
     mov edx,offset space
    call WriteString
     mov edx,offset space
    call WriteString
    ; Read user input for paddle control
    call movePaddle
    ; Game logic (expandable with ball mechanics)
    call DrawBall
    call MoveBall
    call checkBricksCollision
    mov edx,0
    call CheckWinCondition
    cmp edx,0
    je win
    mov eax,80
    call Delay
    call readkey
    cmp al,27
    je EndGame
    cmp al,32
    je wait1
    dec count1
    cmp count1,0
    je decreasepaddlewidth
    cmp count1,-128
    je switchvalue
    jmp gameLoop
EndGame:
    ret
switchvalue:
    mov count1,-1
    jmp gameloop
decreasepaddlewidth:
    sub paddlewidth,5
    mov eax, 13(13*16)
    call settextcolor
    mov dh,26
    mov dl,50
    call gotoxy
    mov ecx,20
    mov edx,offset space
    loop1:
    call WriteString
    loop loop1
    jmp gameloop
win: 
    call winScreen
    ret
 wait1:
    call ReadChar
    cmp al,13
    je gameLoop
    jmp wait1
playGame ENDP


instructions PROC
    instruction_loop:
    mov ecx,50
    call clearscreen
    mov dh,2
    mov dl,53
    call Gotoxy
    mov edx,offset instructionstext
    call WriteString
    mov dh,5
    mov dl,8
    call gotoxy
    mov edx, OFFSET instruction1
    call WriteString
    mov dh,8
    mov dl,8
    call Gotoxy
    mov edx, OFFSET instruction2
    call WriteString
    mov dh,11
    mov dl,8
    call Gotoxy
    mov edx, OFFSET instruction3
    call WriteString
    call ReadChar
    cmp al,27
    jne instruction_loop
    mov ecx,30
    call clearscreen
    ret
instructions ENDP

leaderboard PROC
    call leaderboard1
    ret
leaderboard ENDP

quitProgram PROC
quitp:
    mov ecx,50
    call clearscreen
    mov dl,0
    mov dh,13
    call Gotoxy
    mov edx,offset quitgameprompt
    call writestring
endproc:
    mov ecx,10
    call clearscreen
    invoke exitprocess,0
quitProgram ENDP
welcome_scr PROC
    mov eax, 0 (13 * 16)  
    call SetTextColor
    mov ecx, 600
    mov edx, OFFSET space
    mov dh,1
    mov dl,2
    call Gotoxy    
    mov dl,0
    mov dh, 8
    call Gotoxy
     
    mov eax, 7 (13* 16)
    call SetTextColor
    mov edx,offset border1
loop1:
    call WriteString
    loop loop1
    mov xcord,0
    mov dl, xcord
    mov dh, ycord
    call Gotoxy
    mov eax,13(16*16)
    call SetTextColor
    mov edx, OFFSET helloText
    call WriteString
    call CRLF
    call CRLF

    mov dl, 53
    mov dh, 13
    call Gotoxy
    mov eax,12(11*16)
    call SetTextColor
    mov edx, OFFSET welcomeText
    call WriteString
    call CRLF

    mov dl, 50
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET enterNameText
    call WriteString
    call CRLF
    mov dl, 52
    mov dh, 16
    call Gotoxy
    xor ecx, ecx
    mov ecx, 9
    mov dh,17
    mov dl,56
    call Gotoxy
    xor edx, edx
    mov edx, OFFSET nam
    call ReadString
    mov eax,13(13*16)
    call SetTextColor
    ret
welcome_scr ENDP
main PROC
    call welcome_scr
    mov ecx,20
    call clearscreen
    call inputLoop1
    invoke ExitProcess, 0
    ret
main ENDP

END main