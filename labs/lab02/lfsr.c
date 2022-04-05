#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    int MSB = 0;
    int funcs[4] = {0, 2, 3, 5};
    for (int i = 0; i < 4; i++)
        MSB ^= (*reg >> funcs[i]) & 1;

    *reg >>= 1; // shift right
    // set reg 15th bit to MSB
    *reg |= MSB << 15;
}
