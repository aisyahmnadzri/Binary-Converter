INCLUDE Irvine32.inc
.stack 100h
.data
option1     byte ">>> Please select the conversion type", 0
option2     byte " 1. Binary to Decimal", 0dh, 0ah
byte " 2. Decimal to Binary", 0dh, 0ah
byte " 3. Exit", 0dh, 0ah
byte "-----------------------------------------------------------------", 0
option3     byte "Enter your choice: ", 0
option4     byte "Please Enter 8-bit binary digits (e.g., 11110000): ", 0
option5     byte "The decimal integer of ", 0
option6     byte "b is ", 0
option7     byte "d", 0
option8     byte "Please Enter a decimal integer less than 256: ", 0
option9     byte "The binary of ", 0
option10    byte "d is ", 0
option11    byte "b", 0
option12    byte "Bye.", 0

binarydigit      dword ?
decimaldigit      word ?
totaldecimal      dword ?
counter     dword ?
multiplication       dword ?
digit8      word  8

.code
main PROC

Choice :
mov   edx, OFFSET option1
call  WriteString
call  Crlf
mov   edx, OFFSET option2
call  WriteString
call  Crlf
mov   edx, OFFSET option3
call  WriteString
call  ReadInt


cmp   eax, 1
je    BinarytoDecimal
cmp   eax, 2
je    DecimaltoBinary
cmp   eax, 3
je    EndProgram

BinarytoDecimal :
mov   edx, OFFSET option4
call  WriteString
call  ReadDec
mov   binarydigit, eax
mov   eax, binarydigit
mov   ecx, 0
mov   edx, 0
jmp   L1

L1 :
cmp   eax, 0
je    Check
mov   ebx, 10
div   ebx
push  edx
inc   ecx
xor edx, edx
mov   counter, ecx
mov   totaldecimal, 0
jmp   L1

; check value of bit, 0 or 1, jump to Min if bit = 1
Check:
cmp   ecx, 0
je    Done
pop   edx
mov   multiplication, 1
cmp   edx, 1
je    Min
dec   ecx
mov   counter, ecx
jmp   Check

; check whether it is a lsb
Min :
sub   ecx, 1
cmp   ecx, 0; 1sb = 1
je    Lsb1
jmp   ConvertBinaryBit

; if lsb = 1, then 2 ^ 0 = 1
Lsb1:
mov   eax, 1
jmp   Addit

; if bit = 1, then 2 ^ position of bit
ConvertBinaryBit :
cmp   ecx, 0
je    Addit
mov   eax, multiplication
mov   ebx, 2
mul   ebx
dec   ecx
mov   multiplication, eax
jmp   ConvertBinaryBit

; sum up to get the decimal value
Addit :
mov   ebx, totaldecimal
add   ebx, eax
mov   totaldecimal, ebx
jmp   Subcountervalue

; subtract counter with 1, it means done checkingand converting for 1 bit
Subcountervalue :
sub   counter, 1
mov   ecx, counter
jmp   Check

Done :
mov   edx, OFFSET option5
call  WriteString
mov   eax, binarydigit
call  WriteDec
mov   edx, OFFSET option6
call  WriteString
mov   eax, totaldecimal
call  WriteDec
mov   edx, OFFSET option7
call  WriteString
call  Crlf
call  Crlf

jmp   Choice


; ------------------------------------------------------------------------------------------ -

DecimaltoBinary:
mov   edx, OFFSET option8
call  WriteString
call  ReadDec
mov   decimaldigit, ax
mov   edx, OFFSET option9
call  WriteString
mov   ax, decimaldigit
call  WriteDec
mov   edx, OFFSET option10
call  WriteString
mov   cx, 0
mov   dx, 0
jmp   L2

L2 :
cmp   ax, 0
je    Checkbit
mov   bx, 2
div   bx
push  dx
inc   cx
xor dx, dx
jmp   L2

; check whether the binary number has 8 bit
Checkbit :
cmp   cx, 8
jne   Addbit
je    Print

; if binary number not enough 8 bit, substractand get how many bit need to be assign 0 at the front
Addbit :
sub   digit8, cx
mov   cx, digit8
jmp   Add0

; add 0 to the front for those less than 8 bit
Add0 :
cmp   cx, 0
je    Setcounter
mov   dx, 0
push  dx
xor dx, dx
dec   cx
jmp   Add0

; set initial cx to 8
Setcounter:
mov   cx, 8
jmp   Print

; display result
Print :
cmp   cx, 0
je    Done1
pop   dx
mov   ax, dx
call  WriteDec
dec   cx
jmp   Print

Done1 :
mov   edx, OFFSET option11
call  WriteString
call  Crlf
call  Crlf

jmp   Choice

; ------------------------------------------------------------------------------------------ -

EndProgram:
mov   edx, OFFSET option12
call  WriteString
ret


main ENDP
END main
