global main

main:
    mov eax, 1
    mov ebx, 1
    mov ecx, 3
    mov edx, 0
fib:
    cmp ecx, 1
    je end
    add edx, eax
    add edx, ebx
    mov eax, ebx
    mov ebx, edx
    sub ecx, 1
    jmp fib
end:
    mov eax, edx
    ret

