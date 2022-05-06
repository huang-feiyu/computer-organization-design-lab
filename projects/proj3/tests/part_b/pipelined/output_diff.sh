#!/bin/bash

printf "=====cpu-mem=====\n"
python3 binary_to_hex_cpu.py reference_output/cpu-mem-ref.out > cpu-mem-reference.out
python3 binary_to_hex_cpu.py student_output/cpu-mem-student.out > cpu-mem-student.out
diff cpu-mem-reference.out cpu-mem-student.out

rm ./*.out -f

