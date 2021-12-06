#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <wait.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/ipc.h>

static const int SHMKEY = 5050;

int main(int argc, char* args[])
{
    const int shmId = shmget(SHMKEY, 4096 * 10, 0666 | IPC_CREAT);
    assert(shmId > 0 && "get shm failed!");
    void const * mem = shmat(shmId, 0x0, 0x0);
    const int fd = open("resourse.txt", O_RDONLY);
    assert(fd >= 0 && "open file failed!");
    char buffer[4096 * 10] = {};
    while(read(fd, (void*)buffer, 4096 * 10) != 0){
        memcpy(mem, buffer, 4096 * 10);
    }
    printf("read file task and write it to shm memory finished!\n");
    close(fd);
    sleep(20);
    assert(shmdt(shmId) == 0 && "shm detached filed!");
    assert(shmctl(shmId, IPC_RMID, 0) == 0 && "delete shm failed!");
    return 0;
}

