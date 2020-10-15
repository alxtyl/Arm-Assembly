@decode.s
@Main function to decode a BMP image
@5/24/2020: Garrett Birch + Alex Tyler

@define processors
.cpu cortex-a7
.fpu neon-vfpv4

.data
	fileIn:  .asciz "rainbow_out.bmp"
	rb:	.asciz "rb"
	outputMessage: .asciz "The message encoded in this image is: %s\n"

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4

	@fpin = fopen("rainbow_out.bmp", "rb")
	ldr r0, =fileIn
	ldr r1, =rb
	bl fopen
	push {r0} 		@fpin stored in stack [fp, #-8]

	@filesize = read_int(fpin, 2)
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #2		@r1 = 2 for args
	bl read_int		@call read_int(fpin, 2)
	push {r0}		@store filesize in stack [fp, #-12]

	@offset = read_int(fpin, 10)
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #10		@r1 = 10 for args
	bl read_int		@call read_int(fpin,10)
	push {r0}		@store offset in stack [fp, #-16]

    @width = read_int(fpin, 18)
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #18		@r1 = 18 for args
	bl read_int		@call read_int(fpin, 12)
	push {r0}		@store width in stack [fp, #-20]

    @height = read_int(fpin, 22)
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #22		@r1 = 22 for args
	bl read_int		@call read_int(fpin, 22)
	push {r0}		@store height in stack [fp, #-24]

	@fseek(fpin, offset, SEEK_SET)
	ldr r0, [fp, #-8]	@load fpin into r0 for args
	ldr r1, [fp, #-16]	@load offset into r1 for args 
	mov r2, #0		@load SEEK_SET (= 0) into r2 for args
	bl fseek		
	
	@if ((3*width)%4 != 0)
	ldr r0, [fp, #-20]	@load width into r0
	mov r1, #3
	mul r0, r0, r1		@(3*width) stored in r0
	mov r1, #4		@r1 = 4 to call modulo
	bl modulo		@(3*width)%4 stored in r0
	mov r3, r0		@(3*width)%4 stored in r3 for comparison

	@if (3*width)%4 == 0
	cmp r3, #0
	beq initalizepad
	bne calculatepad
	
	initalizepad:
		@padding = 0 in this case
		mov r0, #0
		push {r0}	@store padding in stack [fp, #-28]
		b decode_image

	calculatepad:
		@padding = (3*width) % 4;
        	@padding = 4 - padding
		@(3*width) % 4 stored in r3
		mov r0, #4
		sub r0, r0, r3
		push {r0}	@store padding in stack [fp, #-28]
		b decode_image

decode_image:
	@B = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-20]	@load width into r1
	ldr r2,	[fp, #-24]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc			@malloc(width*height)
	push {r0}			@store B in stack [fp, #-32]

	@G = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-20]	@load width into r1
	ldr r2,	[fp, #-24]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc			@malloc(width*height)
	push {r0}			@store G in stack [fp, #-36]

	@R = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-20]	@load width into r1
	ldr r2,	[fp, #-24]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc			@malloc(width*height)
	push {r0}			@store R in stack [fp, #-40]
	
	@length = read_image(fpin, B, G, R, height, width, padding)
	@r0 = fpin, r1 = B, r2 = G, r3 = R, rest on stack
	ldr r0, [fp, #-28] 	@padding
	push {r0}
	ldr r0, [fp, #-20] 	@width
	push {r0}
	ldr r0, [fp, #-24] 	@height
	push {r0}
	ldr r0, [fp, #-8]	@fpin
	ldr r1, [fp, #-32]	@B
	ldr r2, [fp, #-36]	@G
	ldr r3, [fp, #-40]	@R

	@ready to call
	bl read_image
	mov r5, r0			@length stored in r5
	@remove extra args	
	pop {r0, r1, r2}
	push {r5}			@length stored in stack [fp, #-44]
	
	@message = (char *) malloc(length+1)
	@ldr r1, [fp, #-32]
	add r6, r5, #1 		@length + 1 stored in r6
	mov r0, r6			@for calling
	bl malloc
	mov r6, r0			@message stored in r6
	push {r0}			@message stored in stack [fp, #-48]



	@call to decode the image
	@decode(B, G, R, height, width, message, length)
	@r0 = B, r1 = G, r2 = R, r3 = height
	@rest need to be pushed right to left on stack
	@ldr r0, [fp, #-44]	@length
	push {r5}	
	@ldr r0, [fp, #-48] @message
	push {r6}
	ldr r0, [fp, #-20]	@width
	push {r0}
	ldr r0, [fp, #-32]	@B
	ldr r1, [fp, #-36]	@G
	ldr r2, [fp, #-40]	@R
	ldr r3, [fp, #-24]	@height
	@ready to call
	bl decode
	@remove extra args
	pop {r0, r1, r2}


	@output message decoded
	ldr r1, [fp, #-48]
	ldr r0, =outputMessage
	bl printf

	@fclose(fpin)
	ldr r0, [fp, #-8]
	bl fclose

	@return call & exit w/ zero
	mov r0, #0
	sub sp, fp, #4
	pop {fp, pc}
