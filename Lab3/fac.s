.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "Enter number to calculate factorial of: "
input: .asciz "%d"
outp1: .asciz "The factorial of %d"
outp2: .asciz " is %d\n"
error: .asciz "Error! Overflowed occured\n"

.text
.align 2
.global main
.global fac
.type main, %function
.type fac, %function
.type overflow, %function

main:
   push {fp, lr}
   add fp, sp, #4
   
   ldr r0, =prompt @ print out user prompt
   bl printf
	
   ldr r0, =input @ user number input
   sub sp, sp, #4
   mov r1, sp
   
   bl scanf
   ldr r7, [sp]

   bl fac 

   mov r0, #0
   sub sp, fp, #4
   pop {fp, pc}

fac:
   push {fp, lr}
   add fp, sp, #4
   
   mov r5, #1 @ counter
   mov r6, #1 @ factorial num

   whileloop:
       UMULL r6, r0, r6, r5
       
       cmp r0, #0
       bne overflow

       add r5, r5, #1

       cmp r5, r7
       bls whileloop
       
   mov r1, r7
   ldr r0, =outp1
   bl printf
   
   mov r1, r6
   ldr r0, =outp2
   bl printf
   
   mov r0, #0
   sub sp, fp, #4
   pop {fp, pc}
  
overflow:
   push {fp, lr}
   add fp, sp, #4
       
   ldr r0, =error
   bl printf
	   
   mov r0, #0
   sub sp, fp, #4
   pop {fp, pc}
	   
	   
