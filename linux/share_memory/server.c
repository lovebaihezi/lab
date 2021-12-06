#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/type.h>
#include <memory.h>
#include <malloc.h>
#include <sys/mman.h>

int main(int argc, char* args[])
{
    const key_t key = 100;
    const int shm_id = shmget(key, 512, 0700 | IPC_CREAT);
    return 0;
}

