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
    assert(argc == 3 && "you need ip and port!");
    const int socket_desc = socket(AF_INET, SOCK_STREAM, 0);
    assert(socket_desc >= 0 && "create socket failed!");
    struct sockaddr_in server;
    server.sin_addr.s_addr = inet_addr(args[1]);
    server.sin_family = AF_INET;
    server.sin_port = htons(atol(args[2]));
    assert(bind(socket_desc, (struct sockaddr *)&server, sizeof(server)) >= 0 && "bind address failed!");
    assert(listen(socket_desc, 1) >= 0 && "listen port failed!");
    printf("socket server successfully listen on %s:%s!\n", args[1], args[2]);
    while (1)
    {
        struct sockaddr_in client_addr;
        unsigned int client_size = sizeof(client_addr);
        const int client_sock = accept(socket_desc, (struct sockaddr *)&client_addr, &client_size);
        char welcome_message[] = "welcome!";
        assert(send(client_sock, welcome_message, sizeof(welcome_message), 0) >= 0 && "send failed!");
        printf("|address : %s\n|port:%i\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
        close(client_sock);
    }
    close(socket_desc);
    return 0;
}
