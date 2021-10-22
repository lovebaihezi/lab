global main

;; a bad loop like :
;; do {
;;     ebx += 1
;;     eax += ebx
;; } while(ebx <= 100);

main:
    mov eax, 0
    mov ebx, 1
_loop:
    add eax, ebx
    add ebx, 1
    cmp ebx, 100
    je  _loop
    ret
;; nasm -felf64 ./main.asm -o main.o && clang -no-pie -Wall -o main && ./main;echo $? 

