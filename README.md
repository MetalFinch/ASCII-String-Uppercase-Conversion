# ASCII-String-Uppercase-Conversion
1.	Task Description
The goal of this project is to implement an 8051-assembly subroutine that converts all lowercase letters ('a'–'z') in a null-terminated ASCII string to uppercase ('A'–'Z').
Other characters, including uppercase letters, digits, and punctuation, must remain unchanged.


2.	Subroutine Design
The solution is modularized into two subroutines:
2.1	STR_CODE2IRAM
Purpose: Copy a null-terminated string from code memory to internal RAM.
2.2	STR_UPPERCASE
Purpose: Convert lowercase letters ('a'–'z') in a string to uppercase ('A'–'Z'). All other characters remain unchanged.

3.	Algorithm:
   1.	Start the program.
2.	Initialize registers:
o	Load the address of the input string into DPTR
o	Load the starting address of RAM into R7.
3.	Copy the string from code memory to internal RAM using the subroutine STR_CODE2IRAM.
4.	Set R7 to point to the beginning of the copied string in RAM.
5.	Call STR_UPPERCASE to convert the string:
o	Load each character into A.
o	If it is between 'a' and 'z', convert it to uppercase.
o	Store the result back into RAM.
o	Repeat until the null terminator (00h) is found.
6.	End: string is fully processed, not that the program stops.


4.	Testing and Results:
1.	Subroutine only modifies lowercase ASCII letters ('a'-'z').
2.	Null terminator or space characters are treated correctly
3.	Uppercase letters remain unchanged
4.	Minimum string length constraint: even a single space is sufficient to test the routine.



