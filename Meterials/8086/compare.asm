
; 다음의 수식을 8086 어셈블리어를 작성한 경우 
;if (a<b) {
;   x = 5;
;   y = c+d;
;}
;else x = c-d;

CR	equ	0dh
LF	equ	0ah

;----------------------
sseg segment para stack 'stack'
    db 64h dup(?)
sseg ends

;----------------------
dseg segment

value_a	db 2
value_b	db 1
value_c	db 4
value_d	db 3

value_x	db 0
value_y	db 0

msg_start	db ' if a < b -> x=5 & y=c+d',CR,LF
 		db '    else -> x=c-d',CR,LF,'$'

msg_c		db CR,LF, 'C = $'
msg_d		db ', D = $'
msg_x		db ', X = $'
msg_y		db ', Y = $'

msg_x_out	db CR,LF,'X = $'

msg_a_in	db CR,LF,'input value for a :$'
msg_b_in	db CR,LF,'input value for b :$'


msg_ge  	db CR,LF,'a >= b$'
msg_les 	db CR,LF,'a < b$'

dseg ends
;----------------------
cseg segment
main proc far
    assume ss:sseg, ds:dseg, cs:cseg

    mov ax, dseg
    mov ds, ax		;set Data Segment

;------------  display message "Condition " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_start
    int 21h			;DOS Function Call 실행

;------------  display message "C = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_c
    int 21h			;DOS Function Call 실행
;---- display value 'c'  ---------------------------    
    mov dl,value_c
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL
;------------  display message "D = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_d
    int 21h			;DOS Function Call 실행
;---- display value 'd'  ---------------------------        
    mov dl,value_d
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL 
;------------  display message "X = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_x
    int 21h			;DOS Function Call 실행
;---- display value 'x'  ---------------------------    
    mov dl,value_x
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL
;------------  display message "Y = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_y
    int 21h			;DOS Function Call 실행
;---- display value 'y'  ---------------------------        
    mov dl,value_y
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL 

;------------  display message "Input a" -----------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_a_in
    int 21h			;DOS Function Call 실행
;--------  get value a from KBD ------------------	
    mov ah,01
    int 21h			;get calue(al) from KBD
    sub	al,'0'			;convert ASCii -> value
    mov ds:value_a,al		;save value a
;------------  display message "Input b" -----------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_b_in
    int 21h			;DOS Function Call 실행
;--------  get value b from KBD ------------------		
    mov ah,01
    int 21h			;get calue(al) from KBD
    sub	al,'0'			;convert ASCii -> value
    mov ds:value_b,al		;save value a

    mov al, ds:value_a	; al <- a 값
    cmp al, ds:value_b	; a값 >= b값
    jae case_a_large_equal	; 크거나 같으면 점프
 	
 ;-----   a 값이 b 보다 작은 경우 ---------------

    mov value_x,5
    mov al, value_c
    add al, value_d
    mov value_y, al		; y <- c + d
    mov dx, offset msg_les
    jmp end_point

;-----   a 값이 b 보다 크거나 같은 경우 ---------------
case_a_large_equal:
    mov al, value_c
    sub al, value_d
    mov value_x, al		; x <- c - d
    mov dx, offset msg_ge

end_point:
    mov ah,09                   ;ah=09: disp string from dx
    int 21h			;DOS Function Call 실행

;------------  display message "X = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_x_out
    int 21h			;DOS Function Call 실행
;---- display value 'x'  ---------------------------    
    mov dl,value_x
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL
;------------  display message "Y = " ------------
    mov ah,09			;ah=09: disp string from dx
    mov dx, offset msg_y
    int 21h			;DOS Function Call 실행
;---- display value 'y'  ---------------------------        
    mov dl,value_y
    add  dl,'0'	 
    mov ah,02h
    int   21h            ;Dispay DL 

;-----------  Program End ------------------------
    mov ah, 4ch
    int 21h			;프로그램 종료 

main endp
cseg ends
    end main