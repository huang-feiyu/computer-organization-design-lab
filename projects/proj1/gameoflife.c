/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Huang - Core Code
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"
#include "debug.h"

void eightNeighbors(Image *img, int row, int col, int *R, int *G, int *B);
void RGB_alive(Image *img, int row, int col, int *R, int *G, int *B);

/* Determines what color the cell at the given row/col should be.
** This function allocates space for a new Color.
** Note that you will need to read the eight neighbors of the cell in question.
** The grid "wraps", so we treat the top row as adjacent to the bottom row
** and the left column as adjacent to the right column.
**/
Color *evaluateOneCell(Image *img, int row, int col, uint32_t rule) {
    assert(img != NULL && col >= 0 && row >= 0);
    Color *next_state = (Color *) malloc(sizeof(Color));
    int is_alive_R = 0, is_alive_G = 0, is_alive_B = 0;
    int neighbors_R = 0, neighbors_G = 0, neighbors_B = 0;

    // current state
    RGB_alive(img, row, col, &is_alive_R, &is_alive_G, &is_alive_B);
    // 8 neighbors
    eightNeighbors(img, row, col, &neighbors_R, &neighbors_G, &neighbors_B);

    // get the specific bit
    next_state->R = rule & (1 << (9 * is_alive_R + neighbors_R)) ? 255 : 0;
    next_state->G = rule & (1 << (9 * is_alive_G + neighbors_G)) ? 255 : 0;
    next_state->B = rule & (1 << (9 * is_alive_B + neighbors_B)) ? 255 : 0;

    return next_state;
}

// The main body of Life; given an image and a rule,
// computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image *life(Image *img, uint32_t rule) {
    assert(img != NULL);
    uint32_t mrow = img->rows;
    uint32_t mcol = img->cols;

    // init new img
    Image *new_img = (Image *) malloc(sizeof(Image));
    new_img->rows = mrow;
    new_img->cols = mcol;
    new_img->image = (Color **) malloc(sizeof(Color *) * mrow * mcol);

    // get every pixel
    Color **p = new_img->image;
    for (int i = 0; i < mrow; i++) {
        for (int j = 0; j < mcol; j++) {
            *p = evaluateOneCell(img, i, j, rule);
            p++;
        }
    }

    return new_img;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life,
then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv) {
    if (argc != 3) {
        printf("usage: ./gameOfLife filename rule\n"
        "filename is an ASCII PPM file (type P3) with maximum value 255.\n"
        "rule is a hex number beginning with 0x; Life is 0x1808.");
        return -1;
    }
    Image *img = readData(argv[1]);
    uint32_t rule = strtol(argv[2], NULL, 16);
    if (img == NULL || rule < 0 || rule > 0x3ffff) {
        debug_wtf("invalid rule");
        return -1;
    }

    // decode and output
    Image *new_img = life(img, rule);
    writeData(new_img);

    freeImage(new_img);
    freeImage(img);
    return 0;
}

// check RGB is alive
void RGB_alive(Image *img, int row, int col, int *R, int *G, int *B) {
    Color **p = img->image;
    (*R) += (p[img->cols * row + col])->R == 255;
    (*G) += (p[img->cols * row + col])->G == 255;
    (*B) += (p[img->cols * row + col])->B == 255;
}

// the eight neighbors (I have no good idea, so the code is silly)
void eightNeighbors(Image *img, int row, int col, int *R, int *G, int *B) {
    int mrow = img->rows;
    int mcol = img->cols;
    int new_row = 0, new_col = 0;
    // left-top
    new_row = (row == 0 ? mrow : row) - 1;
    new_col = (col == 0 ? mcol : col) - 1;
    RGB_alive(img, new_row, new_col, R, G, B);
    // top
    new_row = (row == 0 ? mrow : row) - 1;
    new_col = col;
    RGB_alive(img, new_row, new_col, R, G, B);
    // right-top
    new_row = (row == 0 ? mrow : row) - 1;
    new_col = (col + 1) % mcol;
    RGB_alive(img, new_row, new_col, R, G, B);
    // left
    new_row = row;
    new_col = (col == 0 ? mcol : col) - 1;
    RGB_alive(img, new_row, new_col, R, G, B);
    // right
    new_row = row;
    new_col = (col + 1) % mcol;
    RGB_alive(img, new_row, new_col, R, G, B);
    // left-bottom
    new_row = (row + 1) % mrow;
    new_col = (col == 0 ? mcol : col) - 1;
    RGB_alive(img, new_row, new_col, R, G, B);
    // bottom
    new_row = (row + 1) % mrow;
    new_col = col;
    RGB_alive(img, new_row, new_col, R, G, B);
    // right-bottom
    new_row = (row + 1) % mrow;
    new_col = (col + 1) % mcol;
    RGB_alive(img, new_row, new_col, R, G, B);
}
