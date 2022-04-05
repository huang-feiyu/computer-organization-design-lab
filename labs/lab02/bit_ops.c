#include <stdio.h>
#include "bit_ops.h"
#include "../debug.h"

// Return the nth bit of x.
unsigned get_bit(unsigned x, unsigned n) {
    assert(n >= 0 && n <= 31);
    return (x >> n) & 1;
}

// Set the nth bit of the value of x to v.
void set_bit(unsigned *x, unsigned n, unsigned v) {
    assert(n >= 0 && n <= 31 && (v == 0 || v == 1));
    // clear nth bit, then set nth to 1 if y is 1
    *x = (*x & (~(1 << n))) | (v << n);
}
// Flip the nth bit of the value of x.
void flip_bit(unsigned *x, unsigned n) {
    assert(n >= 0 && n <= 31);
    // better one
    *x ^= (1 << n);
    /*
    unsigned nth_bit = get_bit(*x, n);
    set_bit(x, n, nth_bit == 0 ? 1 : 0);
    */
}
