#include <stdio.h>
int main() {
    int a = 1, b = 1;
    int max = 0;
    scanf("%d", &max);
    for(int i = 1;i != max;i += 1) {
        int c = b;
        b += a;
        a = c;
    }
    printf("%d", b);
}
