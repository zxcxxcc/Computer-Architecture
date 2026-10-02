CR	equ 0dh
LF	equ 0ah

sseg segment para stack 'stack'
    db 64h dup(?)
sseg ends
;----------------------
dseg segment
data1 db 'Program terminated by hit "!"',CR,LF
         db 'Hello 8086 CPU!',CR,LF
         db 'My name is ', '$'
dseg ends
;----------------------
cseg segment
main proc far
    assume ss:sseg, ds:dseg, cs:cseg

    mov ax, dseg
    mov ds, ax

;------  DS:DX의 내용을 화면에 연속출력('$' 만날때까지) --- 
    mov ah, 09
    mov dx, offset data1
    int 21h		;DOS Function Call 실행
;------  Get 1 character from KBD w/o echo ----------    
read_loop:
     mov ah,07h
     int   21h            ;Read 1 char from KBD (AL)
;------ if input = '!' then exit program ------------
     cmp al,'!'
     je  exit_program 
;------ Display character ----------------------
     mov dl,al
     mov ah,02h
     int   21h            ;Display DL 
     jmp read_loop

;-------  프로그램 종료 -------------------
exit_program:
    mov ah, 4ch
    int 21h			;프로그램 종료 
   
main endp
cseg ends
    end main