#include <signal.h>
#include <assert.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include <wait.h>
#include <stdio.h>
#include <stdlib.h>

pthread_mutex_t mutex;

void* read_task(void* args)
{
    pthread_mutex_lock(&mutex);
    char* buffer = (char*)malloc(128);
    scanf("%s", buffer);
    pthread_mutex_unlock(&mutex);
    return (void*)buffer;
}

void* write_task(void* args)
{
    printf("%s\n", (char*)args);
    return (void*)0x0;
}

int main()
{
    pthread_t read, write;
    pthread_mutex_init(&mutex, 0x0);
    pthread_create(&read, 0x0, read_task, 0x0);
    char *s = 0x0;
    pthread_join(read, (void**)&s);
    assert(s != 0x0 && "read failed!");
    pthread_create(&write, 0x0, write_task, (void*)s);
    pthread_join(write, 0x0);
    free(s);
    return 0;
}

