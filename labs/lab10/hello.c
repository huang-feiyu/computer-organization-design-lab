/*
 * @Author: Huang huangblog.com
 * @Date: 2022-03-31 13:46:31
 * @LastEditors: Huang huangblog.com
 * @LastEditTime: 2022-05-07 14:26:08
 * @FilePath: \lab10\hello.c
 * @Description: OpenMP intro program
 *
 * Copyright (c) 2022 by Huang huangblog.com, All Rights Reserved.
 */
#include <omp.h>
#include <stdio.h>

int main() {
// directive
#pragma omp parallel
    {
        // return the current thread ID
        int thread_ID = omp_get_thread_num();
        printf(" hello world %d\n", thread_ID);
    }
}
