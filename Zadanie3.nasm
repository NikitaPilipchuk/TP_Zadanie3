%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro


%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro floatnum 1
    print dlen, dot
    mov dl, %1
    %%_divloop:
        mov al, dh
        mov dh, 10
        mul dh 
        div cl
        mov dh, ah
        mov ah, 0
        dprint
        cmp dh, 0
        jz %%_endloop
        dec dl
        mov eax, 0
        cmp dl, 0
        jnz %%_divloop
    %%_endloop:
%endmacro

%macro dprint 0
    pushd
   
    mov ecx, 10
    mov bx, 0

    %%_divide:
        mov edx, 0
        div ecx
        push dx 
        inc bx
        test eax, eax
        jnz %%_divide
        
        mov cx, bx
        
    %%_digit:
        pop ax
        add ax, '0'
        mov [result], ax
        print 1, result
        dec cx
        cmp cx, 0
        jg %%_digit    
    
    popd
%endmacro



section .text

global _start

_start:

FINIT

mov cx, 0
FCLEX

FILD dword [value]
FSQRT
FMUL dword [factor]
FSTP dword [result]

mov eax, [result]
mov cl, [factor]

print rlen, res
_division:
    div cl
    mov dl, al
    mov dh, ah
    mov eax, 0
    mov al, dl
    mov ebx, 0
    dprint
    cmp dh, 0
    jz  _end  

    floatnum 2


_end:
    print nlen, newline
    print len, message
    print nlen, newline
    
    mov eax, 1
    int 0x80

section .data
    value dq 52896
    vlen equ $ - value
    result dq 0
    reslen equ $ - result
    factor dd 100
    
    res db "Result: "
    rlen equ $ - res
    message db "Done"
    len equ $ - message
    minus db "-"
    mlen equ $ - minus
    dot db "."
    dlen equ $ - dot
    newline db 0xA, 0xD
    nlen equ $ - newline
    

segment .bss
sum resb 1