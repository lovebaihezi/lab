#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <malloc.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/socket.h>
#include <wait.h>
#include <malloc.h>

void f() {
    printf("hello");
}

int main() {
    signal(SIGINT, f);
    pause();
    return 0;
}
