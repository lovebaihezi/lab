#include <algorithm>
#include <array>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iostream>
#include <memory.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>
typedef struct message_buffer
{
    long type;
    char message[512];
} message_buffer;

inline void message_send(int message_id, char *message, size_t message_size)
{
    static int time = 1;
    message_buffer mes;
    mes.type = time;
    time += 1;
    memccpy(mes.message, message, '\0', message_size);
    mes.message[message_size] = '\0';
    printf("send message: %20s|\n", mes.message);
    msgsnd(message_id, &mes, sizeof(mes), 0);
}

inline void message_receive(int message_id)
{
    static int time = 0;
    message_buffer mes;
    msgrcv(message_id, &mes, sizeof(mes), time, time);
    printf("received message: %s|\n", mes.message);
}

int main(int argc, char *args[])
{
    const auto pid = fork();
    assert(pid != -1 && "fork failed!");
    const key_t key = 5050;
    const auto auth = 0666; // only user and root
    const auto message_queue_id = msgget(key, auth | IPC_CREAT);
    for (int i = 1; i < argc; i++)
    {
        if (pid == 0)
        {
            // if (i % 2 == 1)
            // {
            message_send(message_queue_id, args[i], strlen(args[i]));
            // }
            // else
            // {
            //     message_receive(message_queue_id);
            // }
        }
        else
        {
            wait(0x0);
            // if (i % 2 == 1)
            // {
            message_receive(message_queue_id);
            // }
            // else
            // {
            //     message_send(message_queue_id, args[i], strlen(args[i]));
            // }
        }
    }
    msgctl(message_queue_id, IPC_RMID, 0x0);
    return 0;
}
