#include <stdio.h>
int main() {
    int a[5] = {1, 2, 3, 4, 5};
    unsigned total = 0;
    // https://wiki.sei.cmu.edu/confluence/display/c/ARR01-C.+Do+not+apply+the+sizeof+operator+to+a+pointer+when+taking+the+size+of+an+array
    for (int j = 0; j < 5; j++) {
        total += a[j];
        // printf("%dth time: sizeof(a) %ld\n", j, sizeof(a));
    }
    printf("sum of array is %u\n", total);
}