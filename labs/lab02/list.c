#include "list.h"
#include "../debug.h"

/* Add a node to the end of the linked list. */
void append_node (node* *head_ptr, int new_data) {
    assert(head_ptr != NULL);

    // init node
    node *new_node = (node*) malloc(sizeof(node));
    new_node->next = NULL;
    new_node->val = new_data;

    // corner case: empty list
    if (*head_ptr == NULL) {
        *head_ptr = new_node;
        return;
    }
    // to get the last node
    node* curr = *head_ptr;
    while (curr->next != NULL) {
        curr = curr->next;
    }

    // insert new code
    curr->next = new_node;
}

/* Reverse a linked list in place. */
void reverse_list (node** head_ptr) {
    assert(head_ptr != NULL);

    /*
    node* prev = NULL;
    node* curr = *head_ptr;
    node* next = NULL;
    while (curr != NULL) {
        next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }
    // Set the new head to be what originally was the last node in the list
    *head_ptr = prev;
    */
    *head_ptr = reverse_list_recursive((*head_ptr));
}

node* reverse_list_recursive(node *head) {
    if (head == NULL || head->next == NULL)
        return head;
    node* ret = reverse_list_recursive(head->next);
    head->next->next = head;
    head->next = NULL;
    return ret;
}