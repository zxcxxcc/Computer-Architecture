sseg segment para stack 'stack'
    db 64h dup(?)
sseg ends

;----------------------
dseg segment
dseg ends

;----------------------

cseg segment
main proc far
    assume ss:sseg, ds:dseg, cs:cseg

    mov  al,2			; al 레지스터에 2 설정 
re_check:  
    dec  al         		; al 1 감소
    jnz  re_check 	        ; al<>0 이면 반복
    nop

;-------  프로그램 종료 -------------------
exit_program:
    mov ah, 4ch
    int 21h			;프로그램 종료 
   
main endp
cseg ends
    end main