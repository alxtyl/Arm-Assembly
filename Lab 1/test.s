	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"test.c"
	.text
	.align	2
	.global	test
	.arch armv6
	.syntax unified
	.arm
	.fpu vfp
	.type	test, %function
test: @ This is the test function
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!		@ I wonder what the ! means
	add	fp, sp, #0			@ Adding fp and sp
	sub	sp, sp, #12			@ Subtracting sp and sp
	str	r0, [fp, #-8]		@ Not sure what str does
	ldr	r2, [fp, #-8]		@ Not sure what ldr does
	ldr	r3, .L3				
	smull	r1, r3, r3, r2  @ Not sure what smull does
	asr	r1, r3, #2			@ Not sure what asr does
	asr	r3, r2, #31
	sub	r1, r1, r3			@ Subtracting r1, r1 and r3
	mov	r3, r1				@ Moving r3 and r1?
	lsl	r3, r3, #2			@ Not sure what lsl does
	add	r3, r3, r1			@ Adding r3, r3 and r1
	lsl	r3, r3, #1			
	sub	r1, r2, r3			@ Subtracting r1, r2 and r3
	mov	r3, r1				@ Moving r3 and r1?
	mov	r0, r3				@ Moving r0 and r3?
	add	sp, fp, #0			@ Adding sp and fp
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L4: @ Not sure what happens here
	.align	2
.L3: @ Not sure what happens here
	.word	1717986919
	.size	test, .-test
	.section	.rodata
	.align	2
.LC0: @ Not sure what happens here
	.ascii	"The digit in the ones place of %d is %d\012\000" @ Printing out the calculation
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main: @ Main Function
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}   @ Pushing fp and lr onto the stack
	add	fp, sp, #4     @ Adding the values in fp and sp
	sub	sp, sp, #16    @ Subtracting sp and sp
	str	r0, [fp, #-16] @ Not sure what str does
	str	r1, [fp, #-20] 
	ldr	r3, .L7        @ Not sure what ldr does
	str	r3, [fp, #-8]
	ldr	r0, [fp, #-8]
	bl	test		   @ Not sure what bl does
	mov	r3, r0		   @ Moving r3 and r0 around in memory?
	mov	r2, r3		   @ Moving r2 and r3 around in memory
	ldr	r1, [fp, #-8]
	ldr	r0, .L7+4
	bl	printf
	mov	r3, #0		   @ Moving r3?
	mov	r0, r3		   @ Moving r0 and r3?
	sub	sp, fp, #4	   @ Subtracting sp and fp
	@ sp needed		
	pop	{fp, pc}       @ Popping fp and lr from the stack 
.L8: @ Not sure what this section does
	.align	2
.L7: @ Not sure what this section does
	.word	294
	.word	.LC0
	.size	main, .-main
	.ident	"GCC: (Raspbian 8.3.0-6+rpi1) 8.3.0"
	.section	.note.GNU-stack,"",%progbits
