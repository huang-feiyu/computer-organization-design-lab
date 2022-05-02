#!/bin/bash

printf "=====alu-add=====\n"
python3 binary_to_hex_alu.py reference_output/alu-add-ref.out > alu-add-reference.out
python3 binary_to_hex_alu.py student_output/alu-add-student.out > alu-add-student.out
diff alu-add-reference.out alu-add-student.out

printf "=====alu-comprehensive=====\n"
python3 binary_to_hex_alu.py reference_output/alu-comprehensive-ref.out > alu-comprehensive-reference.out
python3 binary_to_hex_alu.py student_output/alu-comprehensive-student.out > alu-comprehensive-student.out
diff alu-comprehensive-reference.out alu-comprehensive-student.out

printf "=====alu-logic=====\n"
python3 binary_to_hex_alu.py reference_output/alu-logic-ref.out > alu-logic-reference.out
python3 binary_to_hex_alu.py student_output/alu-logic-student.out > alu-logic-student.out
diff alu-logic-reference.out alu-logic-student.out

printf "=====alu-mulh=====\n"
python3 binary_to_hex_alu.py reference_output/alu-mulh-ref.out > alu-mulh-reference.out
python3 binary_to_hex_alu.py student_output/alu-mulh-student.out > alu-mulh-student.out
diff alu-mulh-reference.out alu-mulh-student.out

printf "=====alu-mult=====\n"
python3 binary_to_hex_alu.py reference_output/alu-mult-ref.out > alu-mult-reference.out
python3 binary_to_hex_alu.py student_output/alu-mult-student.out > alu-mult-student.out
diff alu-mult-reference.out alu-mult-student.out

printf "=====alu-shift=====\n"
python3 binary_to_hex_alu.py reference_output/alu-shift-ref.out > alu-shift-reference.out
python3 binary_to_hex_alu.py student_output/alu-shift-student.out > alu-shift-student.out
diff alu-shift-reference.out alu-shift-student.out

printf "=====alu-slt-sub-bsel=====\n"
python3 binary_to_hex_alu.py reference_output/alu-shift-ref.out > alu-slt-sub-bsel-reference.out
python3 binary_to_hex_alu.py student_output/alu-shift-student.out > alu-slt-sub-bsel-student.out
diff alu-slt-sub-bsel-reference.out alu-slt-sub-bsel-student.out

rm ./*.out -f
