#include <arpa/inet.h>
#include <assert.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>
int main(int argc, char *args[])
{
    if (argc != 3)
    {
        printf("Usage: %s <host address> <port> \n", args[0]);
        exit(1);
    }
    const int socket_desc = socket(AF_INET, SOCK_DGRAM, 0);
    assert(socket_desc >= 0 && "create socket failed!");
    struct sockaddr_in server;
    server.sin_addr.s_addr = inet_addr(args[1]);
    server.sin_family = AF_INET;
    server.sin_port = htons(atol(args[2]));
    assert(bind(socket_desc, (struct sockaddr *)&server, sizeof(server)) >= 0 && "bind address failed!");
    printf("socket server successfully bind on %s:%s!\n", args[1], args[2]);
    struct sockaddr_in client_addr;
    unsigned int client_size = sizeof(client_addr);
    char *buf = (char *)malloc(sizeof(char) * 4096);
    while (1)
    {
        assert(recvfrom(socket_desc, buf, 4096, 0, (struct sockaddr *)&client_addr, &client_size) >= 0 && "recvive buf failed!");
        printf("|address:%s\n", inet_ntoa(client_addr.sin_addr));
        printf("|port:%i\n", ntohs(client_addr.sin_port));
        printf("|received:%s\n", buf);
    }
    free(buf);
    close(socket_desc);
    return 0;
}
