@ define our processor
.cpu cortex-a53
.fpu neon-fp-armv8

.data
outp_1: .asciz "Enter first positive integer: "
input_1: .asciz "%d"
outp_2: .asciz "Enter second positive integer: "
input_2: .asciz "%d"
outp_3: .asciz "The GCD is: %d\n"

.text
.align 2
.global main
.type main, %function

main:
mov r4, lr

ldr r0, =outp_1 @ printing out the first user prompt
bl printf

ldr r0, =input_1 @ getting user input
mov r1, sp 
bl scanf
ldr r6, [sp]

ldr r0, =outp_2 @ printing out the second user prompt
bl printf

ldr r0, =input_2 @ getting user input
mov r1, sp 
bl scanf
ldr r7, [sp]

cmphi r7, r6 @ making sure the items are in the right order
movhi r6, r7

whileloop:
udiv r0, r6, r7 @ getting the remainder
mul r1, r0, r7
sub r2, r6, r1

@ Moving the remainder to be the divisor & the previous
@ divisor becomes the new dividend
mov r6, r7
mov r7, r2

cmp r2, #0 @ if r2 > 0, run the loop again
bhi whileloop
	
mov r1, r6  @ r1 = r6
	
ldr r0, =outp_3 @ display the result
bl printf 

mov lr, r4 

@ return 0;
mov r0, #0

@ leave the function by storing the last instruction into pc
bx lr  

	
	
