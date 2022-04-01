/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				Huang - Core Code
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"
#include "debug.h"

/*
** Determines what color the cell at the given row/col should be.
** This should not affect Image, and should allocate space for a new Color.
**/
Color *evaluateOnePixel(Image *img, int row, int col) {
    assert(img != NULL && col >= 0 && row >= 0);
    uint32_t mrow = img->rows;
    uint32_t mcol = img->cols;
    Color *pixel = (Color *) malloc(sizeof(Color));

    // row and col begin from 0
    assert(row <= mrow - 1 && col <= mcol - 1);

    Color *p = img->image[row * mcol + col];
    int LSB = (p->B) & 1;
    pixel->R = pixel->G = pixel->B = LSB * 255;

    return pixel;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *img) {
    assert(img != NULL);
    uint32_t mrow = img->rows;
    uint32_t mcol = img->cols;

    // init new img
    Image *new_img = (Image *) malloc(sizeof(Image));
    new_img->rows = mrow;
    new_img->cols = mcol;
    new_img->image = (Color **) malloc(sizeof(Color *) * mrow * mcol);

    // get every pixel LSB
    Color **p = new_img->image;
    for (int i = 0; i < mrow; i++) {
        for (int j = 0; j < mcol; j++) {
            *p = evaluateOnePixel(img, i, j);
            p++;
        }
    }

    return new_img;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename,
containing a file of ppm P3 format (not necessarily with .ppm file extension).

If the input is not correct, a malloc fails, or any other error occurs,
you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv) {
    assert(argc >= 2);
    Image *img = readData(argv[1]);
    if (img == NULL)
        return -1;

    // decode and output
    Image *new_img = steganography(img);
    writeData(new_img);

    freeImage(new_img);
    freeImage(img);
    return 0;
}