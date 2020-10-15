@encode_image.s
@Encodes a BMP image by manipulating pixels
@5/24/2020: Garrett Birch + Alex Tyler

@define processors
.cpu cortex-a7
.fpu neon-vfpv4

.data

.text
.align 2
.global	encode_image
.type	encode_image, %function

encode_image:
	push {fp, lr}
	add	fp, sp, #4


	@r0 -> unsigned char *B
	@r1 -> unsigned char *G
	@r2 -> unsigned char *R
	@r3 -> int height
	@width, message on stack
	@make room on stack for array and variables
	sub	sp, sp, #40


	@store volatile registers onto stack for later retrieval 
	str	r0, [fp, #-32]	@ *B stored at this memory location
	str	r1, [fp, #-36]	@ *G stored at this memory location
	str	r2, [fp, #-40]	@ *R stored at this memory location 
	str	r3, [fp, #-44]	@ height stored at this memory location

	@srand(KEY) where KEY = 123456
	ldr	r0, =123456	
	bl	srand 			@call to seed

	@int length = strlen(message)
	ldr	r0, [fp, #8]	@r0 = message
	bl	strlen	
	str	r0, [fp, #-12]	@length stored on stack


	@make room for array unsigned char len[3]
	sub	r2, fp, #28	

	@get ready for convert2pixel(length, len)
	ldr	r0, [fp, #-12]  @r0 = length for args
	mov	r1, r2	        @r1 = pointer to len array		
	bl	convert2pixel	@call function

	@B[0] = len[0]
	ldrb	r2, [fp, #-28]	@len[0]
	ldr	r3, [fp, #-32]	@B
	strb	r2, [r3]	@B[0] = len[0]

	@G[0] = len[1]
	ldrb	r2, [fp, #-27]  @len[1]
	ldr	r3, [fp, #-36]	@G
	strb	r2, [r3]	@G[0] = len[1]

	@R[0] = len[2]
	ldrb	r2, [fp, #-26]	@len[2]
	ldr	r3, [fp, #-40]	@R
	strb	r2, [r3]	@R[0] = len[2]


	@int i = 0 for loop counter
	mov	r3, #0		
	str	r3, [fp, #-8]	@store i counter on stack


	loop:

		@load i
		ldr	r2, [fp, #-8]	
		@load length
		ldr	r3, [fp, #-12]	

		@i < length
		cmp	r2, r3			
		bge 	done_loop		


		@c_char = message[i]
		ldr	r3, [fp, #-8]	@load i
		ldr	r2, [fp, #8]	@load message
		add	r3, r2, r3	@message[i]
		ldrb	r3, [r3]	
		strb	r3, [fp, #-13]	@store c_char

		@index = rand() % (height*width - 1)  + 1
		bl	rand		
		ldr	r3, [fp, #-44]	@load height
		ldr	r2, [fp, #4]	@load width;
		mul	r3, r2, r3	@(height * width)
		sub	r3, r3, #1	@(height * width)-1
		mov	r1, r3		@store @(height * width)-1 in r1 for parameter to modulo
		bl modulo		@call modulo
		mov	r3, r0		@store rand() % (height * width - 1) in r3
		add	r3, r3, #1	@rand() % (height * width - 1) + 1 = index stored in r3
		str	r3, [fp, #-20]	@store index on the stack


		@col = (rand() % 3) + 1
		bl	rand		
		mov r1, #3
		bl modulo
		mov r3, r0
		add r3, r3, #1
		str	r3, [fp, #-24] @store color on stack

		@if col == 1 (color = blue)
		cmp	r3, #1
		bne	green

		ldr	r3, [fp, #-20]	@load index
		ldr	r2, [fp, #-32]	@load G
		add	r3, r2, r3	@B[index]
		ldrb	r2, [fp, #-13]	
		strb	r2, [r3]	@B[index] = c_char
			
		b increment_index

		green:
			@if col == 2 (color = green)
			cmp	r3, #2		
			bne	red

			ldr	r3, [fp, #-20]	@load i
			ldr	r2, [fp, #-36]	@load G
			add	r3, r2, r3	@G[index]
			ldrb	r2, [fp, #-13]	
			strb	r2, [r3]	@G[index] = c_char

			b	increment_index
		
		red:
			ldr	r3, [fp, #-20]	@load i
			ldr	r2, [fp, #-40]	@load R
			add	r3, r2, r3	@R[index]
			ldrb	r2, [fp, #-13]	
			strb	r2, [r3]	@R[index] = c_char
		
		increment_index:
			ldr	r3, [fp, #-8]	@load i
			add	r3, r3, #1	@i++
			str	r3, [fp, #-8]	@store i
			
			b	loop

	done_loop:
		@return
		sub	sp, fp, #4
		pop	{fp, pc}


