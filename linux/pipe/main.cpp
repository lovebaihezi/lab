#include <unistd.h>
#include <stdio.h>
#include <wait.h>
#include <stdlib.h>
#include <assert.h>
#include <stdlib.h>

int main(int argc, char* args[])
{
  assert(argc > 1);
  // pipes[0] : parent write, children read
  // pipes[1] : parent read, children write
  int pipes[2][2] = {};
  assert(pipe(pipes[0]) >= 0);
  assert(pipe(pipes[1]) >= 0);
  pid_t pid = fork();
  assert(pid != -1);
  if(pid == 0)
  {
    close(pipes[1][0]);
    close(pipes[0][1]);
    dup2(pipes[0][0], STDIN_FILENO);
    dup2(pipes[1][1], STDOUT_FILENO);
    close(pipes[0][0]);
    close(pipes[1][1]);
    _exit(execl("/bin/sh", "sh", "-c", args[1], 0x0));
  }
  else
  {
    close(pipes[0][0]);
    close(pipes[1][1]);
    char message[] = "test double direction pipes";
    write(pipes[0][1], message, sizeof(message));
    char buf[4096] = {};
    int nread = read(pipes[1][0], buf, sizeof(buf));
    write(2, buf, nread);
  }
  return 0;
}

