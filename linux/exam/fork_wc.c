#include <unistd.h>
#include <wait.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <assert.h>
#include <string.h>

int main(int argc, char* args[])
{
    const pid_t pid = fork();
    assert(pid >= 0 && "fork failed!");
    if (pid == 0) {
        char command[128] = "wc -c ";
        for(int i = 0;i < strlen(args[1]);i++)
            command[i + 6] = *(args[1] + i);
        system(command);
    } else {
        wait(0x0);
    }
    return 0;
}

