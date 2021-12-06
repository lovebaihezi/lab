#include <algorithm>
#include <array>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <functional>
#include <iostream>
#include <semaphore.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

int main(int argc, char **args)
{
    const auto pid = fork();
    assert(pid >= 0 && "fork failed!");
    return 0;
}
