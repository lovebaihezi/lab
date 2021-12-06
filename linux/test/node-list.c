#include <stdio.h>
#include <malloc.h>
#include <assert.h>

typedef struct Node {
    void* val;
    struct Node* next;
} Node;

Node*
reverse_pointer (Node* root) {
    Node* head = NULL;
    while (root != NULL) {
        Node* next = root -> next;
        root -> next = head;
        head = root;
        root = next;
    }
    return head;
}

Node*
reverse_value (Node* root) {
    Node* head = root;
}

void
clearNodeList (Node* root) {
    assert (root != NULL && "need clear List is NULL");
    while (root != NULL) {
        Node* next = root -> next;
        free(root);
        root = next;
    }
}

void
forEach (Node* root, void (f)(void* )) {
    assert (root != NULL);
    while (root != NULL) {
        f (root -> val);
        root = root -> next;
    }
}

void
f (void* start) {
    printf ("%s\n", (char*)start);
}

int
main (int argc, char * args[]) {
    Node* head = (Node*) malloc(sizeof(Node));
    assert (head != NULL && "get memory failed!");
    Node* root = head;
    head -> val = args[0];
    for (int i = 1;i < argc;i++) {
        Node* next = (Node*) malloc(sizeof(Node));
        assert (next != NULL && "get memory failed!");
        next -> val = args[i];
        head = head -> next = next;
    }
//    root = reverse (root);
    forEach (root, f);
    clearNodeList (root);
    return 0;
}
