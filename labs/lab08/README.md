# lab08

> There must be some mistakes, because I do not fully understand all about VM.

[TOC]

## Exercise 1

* 32 * 8 = 32 Bytes
* TLB Hit: 3; TLB Miss: 7;
  Page Hit: 0; Page Fault: 7
* No. Because every single one is dinstinct from another. A series of addresses where the close two is the same.
* 1st Address: EC
    1. EC => 111_01100 (111 is virtual page number, 01100 is offset)
    2. search in Virtual Memory
        111 => 7, not in TLB nor Page Table.
    3. search in Physical Memory (Physical Address: 00_01100)
        Write into TLB and Page Table

## Exercise 2

TLB is the cache of Virtual Page Table.

My Series: 1F, 3F, 5F, 7F, 9F, BF, DF, FF, 1F, 3F

## Exercise 3

Physical Memory size doubled.

## Exercise 4

The TLB reset after every page fault.
