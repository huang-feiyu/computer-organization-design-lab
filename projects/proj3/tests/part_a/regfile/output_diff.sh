#!/bin/bash

printf "=====regfile-allregs=====\n"
python3 binary_to_hex_regfile.py reference_output/regfile-allregs-ref.out > regfile-allregs-reference.out
python3 binary_to_hex_regfile.py student_output/regfile-allregs-student.out > regfile-allregs-student.out
diff regfile-allregs-reference.out regfile-allregs-student.out

printf "=====regfile-insert=====\n"
python3 binary_to_hex_regfile.py reference_output/regfile-insert-ref.out > regfile-insert-reference.out
python3 binary_to_hex_regfile.py student_output/regfile-insert-student.out > regfile-insert-student.out
diff regfile-insert-reference.out regfile-insert-student.out

printf "=====regfile-x0=====\n"
python3 binary_to_hex_regfile.py reference_output/regfile-x0-ref.out > regfile-x0-reference.out
python3 binary_to_hex_regfile.py student_output/regfile-x0-student.out > regfile-x0-student.out
diff regfile-x0-reference.out regfile-x0-student.out

printf "=====regfile-zero=====\n"
python3 binary_to_hex_regfile.py reference_output/regfile-zero-ref.out > regfile-zero-reference.out
python3 binary_to_hex_regfile.py student_output/regfile-zero-student.out > regfile-zero-student.out
diff regfile-zero-reference.out regfile-zero-student.out

rm ./*.out -f

