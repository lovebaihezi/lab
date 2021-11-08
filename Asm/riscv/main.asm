global main

;; 1 2 3 4 5 6 7  8  9  10
;; 1 1 2 3 5 8 13 21 34 55

main:
    mov eax, 1
    mov ebx, 1
    mov ecx, 9
fib:
    cmp ecx, 1
    je end
    mov edx, ebx
    add ebx, eax
    mov eax, edx
    sub ecx, 1
    jmp fib
end:
    mov eax, ebx
    ret
