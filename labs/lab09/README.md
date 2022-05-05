# lab09

[TOC]

## SIMD

> Single Instruction stream, Multiple Data stream

[SIMD Visualiser](https://piotte13.github.io/SIMD-Visualiser/#/)

An Instruction Operation on multiple data streams in parallel.

For this segment, we use intel `vector` to implement SIMD. (Work on every SIMD machine)

## Unrolling

By performing more operations per iteration, we can loop less to reduce time comsumption. (less branch instructions)

This is a little increase.

## Bugs

### `sum_simd`

1. reference is much bigger than ours

```output
OH NO! SIMD sum 12320768 doesn't match reference sum 412646965248
```

```c
for (i = 0; i <= NUM_ELEMS - 4; i += 4) {
    __m128i vec_tmp = _mm_loadu_si128((__m128i *)(vals + i)); // cast to vec
    __m128i vec_gt = _mm_cmpgt_epi32(vec_tmp, _127); // whether is greater than 127
    vec_tmp = _mm_and_si128(vec_gt, vec_tmp);
    _mm_add_epi32(vec_tmp_sum, vec_tmp);
}
```

The 5th line is wrong, it should be `vec_tmp_sum = _mm_add_epi32(vec_tmp_sum, vec_tmp);`

2. reference is much smaller than ours

```output
OH NO! SIMD sum 560250737688576 doesn't match reference sum 412646965248!
```

```c
unsigned int vec_res[4];
__m128i vec_tmp_sum = _mm_setzero_si128();
for (unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
    int i;
    // inner loop
    // other code ...
```

Obviously, I forgot to reset `vec_tmp_sum` after each iteration.

### `sum_simd_unrolled`

None

## Output

```output
Let's generate a randomized array.
Starting randomized sum.
Time taken: 23.484375 s
Sum: 412646965248
Starting randomized unrolled sum.
Time taken: 14.890625 s
Sum: 412646965248
Starting randomized SIMD sum.
Time taken: 4.984375 s
Sum: 412646965248
Starting randomized SIMD unrolled sum.
Time taken: 4.546875 s
Sum: 412646965248
```
