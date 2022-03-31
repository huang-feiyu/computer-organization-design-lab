#include <stddef.h>
#include <stdbool.h>
#include "ll_cycle.h"

/*
typedef struct node {
    int value;
    struct node *next;
} node;
*/
int ll_has_cycle(node *head) {
    if (head == NULL || (head->next == NULL)) {
        return false;
    }
    node *tortoise = head; // 1 step per move
    node *hare = head->next; // 2 steps per move

    while (tortoise != hare) {
        if (hare == NULL || hare->next == NULL) {
            return false;
        }
        tortoise = tortoise->next;
        hare = hare->next->next;
    }

    return true;
}
