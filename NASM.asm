Running the Program:
Save the code in a file named gcd.asm.
Assemble the code using NASM:
sh
Copier le code
nasm -f elf32 gcd.asm -o gcd.o
Link the object file to create an executable:
sh
Copier le code
./g
This code calculates the GCD of the two numbers a and b specified in the data section and stores the result in the gcd_result variable. You can modify the values of a and b to calculate the GCD of different numbers.
