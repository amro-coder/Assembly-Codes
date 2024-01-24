%include "io.inc"
extern _printf
section .data
table: db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",0
input: db "QVMxNjQwNzM=",0
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
    cmp al,"="
    je resumeLength
    xor edx,edx
    conversion:
    cmp al,[ebx+edx]
    je resumeConversion 
    jne returnToConversion
    
    returnToConversion:
    inc edx
    jmp conversion
    
    resumeConversion:
    mov [esi],dl   
    resumeLength:
    inc esi
    cmp al,0
    jz  restRegisters
    jnz computeLength
    computeLength:
    inc ecx
    jmp length
    
    restRegisters:
    xor edx,edx
    xor ebx,ebx
    xor eax,eax
    mov esi,input
    jmp code
    
    code:
    mov eax,[esi]
    bswap eax
    cmp ecx,0
    je finished
    jne decode
    
    
    decode:
    mov edx,eax
    cmp ah,"="
    je case2
    cmp al,"="
    je case1
    jmp genralCase
    
    case1:
    mov ebx,eax
    shr eax,16
    shr al,4
    shr ebx,24
    shl bl,2
    or al,bl
    mov [edi],al
    inc edi
    mov eax,edx
    mov ebx,edx
    shr eax,8
    shr al,2
    shr ebx,16
    shl bl,4
    or al,bl
    mov [edi],al
    inc edi
    sub ecx,4
    add esi,4
    jmp code
     
    case2:
    mov ebx,eax
    shr eax,16
    shr al,4
    shr ebx,24
    shl bl,2
    or al,bl
    mov [edi],al
    inc edi
    sub ecx,4
    add esi,4
    jmp code
    
    
    genralCase:
    mov ebx,eax
    shr eax,16
    shr al,4
    shr ebx,24
    shl bl,2
    or al,bl
    mov [edi],al
    inc edi
 
    mov ebx,edx
    mov eax,edx
    shr eax,16
    shl al,4
    shr ebx,8
    shr bl,2
    or al,bl
    mov [edi],al
    inc edi
    
    mov eax,edx
    mov ebx,eax
    shr ebx,8
    shl bl,6
    or al,bl
    mov [edi],al
    inc edi
    sub ecx,4
    add esi,4
    jmp code
    
    
    
    
    finished:
    mov byte[edi],00000000b;terminator
    push output
    call _printf
    add esp,4

    
    ret