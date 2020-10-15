@decoder.s
@Decodes a BMP image
@5/25/2020: Garrett Birch + Alex Tyler

@define processors
.cpu cortex-a7
.fpu neon-vfpv4

.data

.text
.align 2
.global decode
.type decode, %function

decode:
	push {fp, lr}
	add fp, sp, #4

	@r0 -> unsigned char *B
	@r1 -> unsigned char *G
	@r2 -> unsigned char *R
	@r3 -> int height
	@int width, char *message, int size stored on stack
	@push parameters onto stack
	push {r0, r1, r2, r3}

	@height at [fp, #-8]
	@R at [fp, #-12]
	@G at [fp, #-16]
	@B at [fp, #-20]

	@srand(KEY) KEY = 123456
	ldr r0, =123456
	bl srand

	@int i = 0, stored in r4
	mov r4, #0

decode_loop:
	@i < size
	ldr r5, [fp, #12] @load size into r6 for loop comparison
	cmp r4, r5
	bge done_decode

	@pixel_ind = (rand() % (height*width - 1)) + 1;
	bl rand 		@rand stored in r0
	@height * width
	ldr r1, [fp, #-8] 	@height stored in r1
	ldr r2, [fp, #4]	@width stored in r2
	mul r1, r1, r2 		@height*width stored in r1
	@height * width -1
	sub r1, r1, #1		@(height*width)-1 stored in r1
	@(rand() % (height*width - 1)
	bl modulo 		@(rand() % (height*width - 1)) stored in r0
	@(rand() % (height*width - 1)) + 1
	add r0, r0, #1		@(rand() % (height*width - 1)) + 1 stored in r0
	mov r6, r0		    @pixel_ind stored in r6

	@color_ind = (rand() % 3) + 1;
	bl rand				@rand stored in r0
	@(rand() % 3)
	mov r1, #3
	bl modulo			@(rand() % 3) stored in r0
	@(rand() % 3) + 1
	add r0, r0, #1		@(rand() % 3) + 1 stored in r0
	mov r7, r0			@color stored in r7
	

	ldr r2, [fp, #8] 	@message stored in r2
	@message + i
	add r2, r2, r4		@*(message + i) stored in r2
	
	@if else statements
	cmp r7, #1
	bne else_if

	@*(B + pixel_ind)
	ldr r1, [fp, #-20]	@*B stored in r1
	add r6, r6, r1	
	ldrb r6, [r6]		@*(B + pixel_ind) stored in r6
	@*(message + i) = *(B + pixel_ind)
	str r6, [r2]
	
	b index_increment

	else_if:
		cmp r7, #2
		bne else
		
		@*(message + i) = *(G + pixel_ind)
		@*(G + pixel_ind)
		ldr r1, [fp, #-16]	@*G stored in r1
		add r6, r6, r1		
		ldrb r6, [r6]		@*(G + pixel_ind) stored in r6
		@*(message + i) = *(G + pixel_ind)
		str r6, [r2]

		b index_increment
		
		

	else:
		@*(message + i) = *(R + pixel_ind);
		@*(R + pixel_ind)
		ldr r1, [fp, #-12]	@*R stored in r1
		add r6, r6, r1		
		ldrb r6, [r6]		@*(R + pixel_ind) stored in r6
		@*(message + i) = *(R + pixel_ind)
		str r6, [r2]

		b index_increment
		
		
	index_increment:
		@i++
		add r4, r4, #1
		b decode_loop
		
		
done_decode:
	@*(message + size) = '\0';
	ldr r3, [fp, #8]
	ldr r4, [fp, #12]
	add r3, r3, r4
	ldr r3, [r3]

	@return call & exit w/ zero
	mov r0, #0
	sub sp, fp, #4
	pop {fp, pc}



