#include <assert.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

pthread_mutex_t mutex;
volatile int sum = 0;

void *thread1(int *args)
{

    pthread_mutex_lock(&mutex);
    int s = 0;
    for (int i = 0; i < 10; i++)
        s += *(args + i);
    sum += s;
    pthread_mutex_unlock(&mutex);
    return (void *)0x0;
}

int main(int argc, char *args[])
{
    volatile int a[4][10] = {};
    pthread_mutex_init(&mutex, 0x0);
    assert(argc == 3 && "arguments should be 3!");
    const int start = atoi(args[1]);
    const int step = atoi(args[2]);
    int right = 0;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            a[i][j] = start * (i + 1) + step * j;
            right += a[i][j];
        }
    }
    pthread_t thread[4] = {};
    for (int i = 0; i < 4; i++)
        pthread_create(thread + i, 0x0, (void *(*)(void *))thread1, (void *)a[i]);
    for (int i = 0; i < 4; i++)
        pthread_join(thread[i], 0x0);
    pthread_mutex_destroy(&mutex);
    assert(right == sum && "it should equal, but not");
    return 0;
}
