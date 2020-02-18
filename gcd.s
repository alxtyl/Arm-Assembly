@ define our processor
.cpu cortex-a53
.fpu neon-fp-armv8

.data
@ printf
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
