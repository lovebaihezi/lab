#include <cassert>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <pthread.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

void *wc_c(void *file_name)
{
    char command[60] = "wc -c ";
    for (int i = 0; i < strlen((char *)file_name); i++)
    {
        command[i + 6] = *((char *)file_name + i);
    }
    system(command);
    return (void *)0x0;
}

void *wc_l(void *file_name)
{
    char command[60] = "wc -l ";
    for (int i = 0; i < strlen((char *)file_name); i++)
    {
        command[i + 6] = *((char *)file_name + i);
    }
    system(command);
    return (void *)0x0;
}

void *wc_w(void *file_name)
{
    char command[60] = "wc -w ";
    for (int i = 0; i < strlen((char *)file_name); i++)
    {
        command[i + 6] = *((char *)file_name + i);
    }
    system(command);
    return (void *)0x0;
}

int main(int argc, char **args)
{
    pthread_t *thread = (pthread_t *)malloc(sizeof(pthread_t) * 3);
    for (int i = 1; i < argc; i++)
    {
        {
            const auto result = pthread_create(thread, 0x0, wc_c, args[i]);
            assert(result >= 0);
        }
        {
            const auto result = pthread_create(thread + 1, 0x0, wc_w, args[i]);
            assert(result >= 0);
        }
        {
            const auto result = pthread_create(thread + 2, 0x0, wc_l, args[i]);
            assert(result >= 0);
        }
        for (int i = 0; i < 3; i++)
            pthread_join(thread[i], (void **)0x0);
    }

    free(thread);
    return 0;
}
