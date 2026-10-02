CR	equ 0dh
LF	equ 0ah

sseg segment para stack 'stack'
    db 64h dup(?)
sseg ends

;----------------------
dseg segment
data1 db 'Stack Test',CR,LF,'$'
dseg ends

;----------------------
cseg segment
main proc far
    assume ss:sseg, ds:dseg, cs:cseg

    mov ax, dseg
    mov ds, ax

    mov ax, 1234h	; ax 레지스터에 1234h 값 넣음
    mov dx, 5678h	; dx 레지스터에 5678h 값 넣음

;------  DS:DX의 내용을 화면에 연속출력('$' 만날때까지) --- 
    push ax		; ax 내용을 스택에 저장
    push dx		; dx 내용을 스택에 저장

;    mov ah, 09
;    mov dx, offset data1
;    int 21h		;DOS Function Call 실행

    cld			;자동증가 순방향 설정
    mov si, offset data1

display_loop:
    lodsb		;al <- ds:si & si <- si+1 = 자동증가 어드레싱 모드
    cmp al,'$'
    je    display_end	;if $ then exit loop   
    
    mov dl,al
    mov ah,02h
    int   21h            ;Dispay DL 
    jmp display_loop

display_end:
    pop  dx		; 스택에 저장된 dx를 복원
    pop  ax		; 스택에 저정된 ax를 복원

; ----- pop 명령은 먼저 push 된 순서로 먼저 꺼내진다 
    push ax		; ax = 1234h
    push dx		; dx = 5678h
    mov  ax,0
    mov  dx,0
    pop  ax		; 나중에 저장된 5678h가 ax로 복원
    pop  dx		; 그 이전에 저장된 1234h가 dx로

;-------  프로그램 종료 -------------------
    mov ah, 4ch
    int 21h			;프로그램 종료 
   
main endp
cseg ends
    end main