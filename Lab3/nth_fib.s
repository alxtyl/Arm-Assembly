@ define our processor
.cpu cortex-a53
.fpu neon-fp-armv8

@ define our constants and global variables
.data
outPrompt: .asciz "Enter Fibonacci term: "
input: .asciz "%d"
outp1: .asciz "The %dth "
outp2: .asciz "Fibonacci term is: %d\n"
error: .asciz "Error! Overflow occured at n = %d\n"


@ define the text section for the assembler to
@ generate binary instructions

.text
.align 2
.global main
.type main, %function
.type overflow, %function

@ define function main

main:
   push {fp, lr}
   add fp, sp, #4
   
   ldr r0, =outPrompt
   bl printf
     
   sub sp, sp, #4
     
   ldr r0, =input
   mov r1, sp 
   bl scanf
     
   ldr r9, [sp]
     
   @ store the first two values of the sequence into 
   @ registers

   mov r5, #1
   mov r6, #1

   @ initialize counter variable n to 3 (third term)
   mov r7, #3   @ n = 3 or r7 = 3

   @ The sequence we are calculating
   @ x(n) = 2*x(n-1) + x(n-2)
   @ x(0) = 1, x(1) = 2  (a = x(0) and b = x(1))

   whileloop:
      adds r8, r5, r6
      bcs overflow

      mov r5, r6  @ a = b
      mov r6, r8  @ b = c

      @ checking to see if the user input equals 1 or 2
      @ if so, auto return 1 since the first two nums of the sequnece
      @ are equal to 1
      cmpls r9, #2 
      movls r8, #1
     
      @ increment out counter n
      add r7, r7, #1  @ n = n + 1

      cmp r7, r9     @ check r7 vs user input
      ble whileloop  @ if (r7 < user input) goto whileloop

   @ set the print arguments
   @ the first argument of printf needs to go into r0
   @ the second argument of printf goes into r1
   @ printf("The result is: %d\n", c);
   @ printf(outp, r8)
   @ r0 <-- outp,  r1 <-- r8

   mov r1, r9  @ r1 = r9

   ldr r0, =outp1 
   bl printf

   mov r1, r8
   ldr r0, =outp2

   bl printf @ calls the printf function from C.  The bl branches to
             @ the function address printf and stores the current value
             @ of the pc into lr

   @ restore the value of lr to get back to where we came from
   mov lr, r4  @ r4 contains the address of the instruction where we came from

   @ return 0;
   mov r0, #0
   sub sp, fp, #4
   pop {fp, pc}
   
overflow: 
   mov r1, r7
   
   ldr r0, =error
   bl printf
   
   mov r0, #0
   sub sp, fp, #4
   pop {fp, pc}
   
   
   

