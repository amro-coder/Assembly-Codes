%include "io.inc"
extern _printf
section .data
table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",0
input: db "AS164073",0
output: db "this output dose not matter and should be longer than the input for some reason"
section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax,eax
    xor ecx,ecx
    xor edx,edx
    mov ebx,table
    mov esi,input
    mov edi,output
    length:
    mov al,[esi]
    inc esi
    cmp al,0
    jz  restRegisters
    jnz computeLength
    computeLength:
    inc ecx
    jmp length
    
    restRegisters:
    xor eax,eax
    mov esi,input
    jmp code
    
    code:
    mov eax,[esi]
    bswap eax
    cmp ecx,3
    jge threeByteCode
    cmp ecx,2
    je twoByteCode
    cmp ecx,1
    je oneByteCode
    cmp ecx,0
    je finished
    
    
    threeByteCode:
    shr eax,8
    mov edx,eax
    shr eax,18
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    shr eax,12
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    shr eax,6
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    add esi,3
    sub ecx,3
    jmp code
    
    
    twoByteCode:
    shr eax,16
    mov edx,eax
    shr eax,10
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    shr eax,4
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    shl eax,2
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    mov byte[edi],"="
    inc edi
    add esi,2
    sub ecx,2
    jmp code
    
    
    oneByteCode:
    shr eax,24
    mov edx,eax
    shr eax,2
    xlat
    mov [edi],al
    inc edi
    mov eax,edx
    shl eax,4
    and eax,0x0000003f
    xlat
    mov [edi],al
    inc edi
    mov word[edi],"=="
    add edi,2
    
    add esi,1
    sub ecx,1
    jmp code
    
    
    finished:
    mov byte[edi],00000000b
    push output
    call _printf
    add esp,4
    
    ret