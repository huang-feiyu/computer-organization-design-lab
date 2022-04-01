/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				Huang - Core Code
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"
#include "debug.h"

/*
** Opens a .ppm P3 image file, and constructs an Image object.
** You may find the function fscanf useful.
** Make sure that you close the file with fclose before returning.
**/
Image *readData(char *filename) {
    assert(filename != NULL);
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        debug_wtf("file open failed");
        return NULL;
    }
    Image *img = (Image *) malloc(sizeof(Image));

    // first three lines
    char buf[3];
    uint32_t maxcolor;
    fscanf(fp, "%s", buf);
    if (buf[0] != 'P' || buf[1] != '3') {
        debug_wtf("file format wrong");
        return NULL;
    }
    fscanf(fp, "%u", &(img->cols));
    fscanf(fp, "%u", &(img->rows));
    fscanf(fp, "%u", &maxcolor);
    assert(img->rows >= 0 && img->cols >= 0 && maxcolor == 255);
    // debug("rows: %u\tcols: %u", img->rows, img->cols);

    // pixels
    int total_pixel = img->rows * img->cols;
    img->image = (Color **) malloc(total_pixel * sizeof(Color *));
    for (int i = 0; i < total_pixel; i++) {
        (img->image)[i] = (Color *) malloc(sizeof(Color));
        Color *pixel = img->image[i];
        // 3 times to remove spaces
        fscanf(fp, "%hhu", &pixel->R);
        fscanf(fp, "%hhu", &pixel->G);
        fscanf(fp, "%hhu", &pixel->B);
    }

    fclose(fp);
    return img;
}

// Given an image, prints to stdout (e.g. with printf)
// a .ppm P3 file with the image's data.
void writeData(Image *img) {
    assert(img != NULL);
    uint32_t rows = img->rows;
    uint32_t cols = img->cols;
    printf("P3\n%u %u\n255\n", cols, rows); // first 3 lines

    Color **p = img->image; // pixel pointer
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols - 1; j++) {
            printf("%3hhu %3hhu %3hhu   ", (*p)->R, (*p)->G, (*p)->B);
            p++;
        }
        printf("%3hhu %3hhu %3hhu\n", (*p)->R, (*p)->G, (*p)->B);
        p++;
    }
}

// Frees an image
void freeImage(Image *img) {
    for (int i = 0; i < img->rows * img->cols; i++) {
        free(img->image[i]);
    }
    free(img->image);
    free(img);
}