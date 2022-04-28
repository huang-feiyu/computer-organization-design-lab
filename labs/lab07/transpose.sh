#!/bin/bash

make

printf "\nPart 1\n"
./transpose 100 20
./transpose 1000 20
./transpose 2000 20
./transpose 5000 20
./transpose 10000 20

printf "\nPart 2\n"
./transpose 10000 50
./transpose 10000 100
./transpose 10000 500
./transpose 10000 1000
./transpose 10000 5000
