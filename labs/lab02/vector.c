/* Include the system headers we need */
#include <stdlib.h>
#include <stdio.h>

/* Include our header */
#include "vector.h"

/* Define what our struct is */
struct vector_t {
    size_t size;
    int *data;
};

/* Utility function to handle allocation failures. In this
   case we print a message and exit. */
static void allocation_failed() {
    fprintf(stderr, "Out of memory.\n");
    exit(1);
}

/* Bad example of how to create a new vector */
vector_t *bad_vector_new() {
    /* Create the vector and a pointer to it */
    vector_t *retval, v;
    retval = &v;

    /* Initialize attributes */
    retval->size = 1;
    retval->data = malloc(sizeof(int));
    if (retval->data == NULL) {
        allocation_failed();
    }

    retval->data[0] = 0;
    return retval;
}

/* Another suboptimal way of creating a vector */
vector_t also_bad_vector_new() {
    /* Create the vector */
    vector_t v;

    /* Initialize attributes */
    v.size = 1;
    v.data = malloc(sizeof(int));
    if (v.data == NULL) {
        allocation_failed();
    }
    v.data[0] = 0;
    return v;
}

/*  Create a new vector with a size (length) of 1
    and set its single component to zero... the
    RIGHT WAY */
vector_t *vector_new() {
    vector_t *retval;

    // allocate struct memory
    retval = (vector_t*) malloc(sizeof(vector_t));
    if (retval == NULL) {
        allocation_failed();
    }

    // init member
    retval->size = 1;
    retval->data = (int*) malloc(sizeof(int));;
    if (retval->data == NULL) {
        free(retval);
        allocation_failed();
    }

    // init data with 0
    retval->data[0] = 0;

    return retval;
}

/* Return the value at the specified location/component "loc" of the vector */
int vector_get(vector_t *v, size_t loc) {

    // If we are passed a NULL pointer for our vector, complain about it and exit
    if (v == NULL) {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        abort();
    }


    return loc < v->size ? v->data[loc] : 0;
}

// Free up the memory allocated for the passed vector.
void vector_delete(vector_t *v) {
    if (v == NULL) {
        fprintf(stderr, "vector_delete: passed a NULL vector.\n");
        abort();
    }

    free(v->data);
    free(v);
}

/*  Set a value in the vector. If the extra memory allocation fails, call
    allocation_failed(). */
void vector_set(vector_t *v, size_t loc, int value) {
    if (v == NULL) {
        fprintf(stderr, "vector_set: passed a NULL vector.\n");
        abort();
    }

    // donot need allocate more memory
    if (loc < v->size) {
        v->data[loc] = value;
        return;
    }

    // realloc the data array
    size_t prev_size = v->size;
    v->size = loc + 1;
    v->data = realloc(v->data, v->size * sizeof(int));
    if (v->data == NULL) {
        vector_delete(v);
        allocation_failed();
    }

    // assign the value
    for (size_t i = prev_size; i < loc; i++)
        v->data[i] = 0;
    v->data[loc] = value;
}