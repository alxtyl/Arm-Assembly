@ define our processor
.cpu cortex-a53
.fpu neon-fp-armv8

.data
@ printf
@outp_1: .asciz "Enter first positive integer: "
@input_1: .asciz "%d"
@outp_2: .asciz "Enter second positive integer: "
@input_2: .asciz "%d"
outp_3: .asciz "The GCD is: %d\n"

.text
.align 2
.global main
.type main, %function

main:
mov r4, lr
	
mov r6, #45
mov r7, #210

cmphi r7, r6
movhi r6, r7

whileloop:

udiv r0, r6, r7
mul r1, r0, r7
sub r2, r6, r1

mov r6, r7
mov r7, r2

cmp r2, #0
bhi whileloop
	
mov r1, r6  @ r1 = r6
	
ldr r0, =outp_3

bl printf 

mov lr, r4
mov r0, #0

bx lr  

	
	
