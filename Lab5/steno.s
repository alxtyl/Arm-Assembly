@steno.s
@5/25/2020: Garrett Birch + Alex Tyler

@define processors
.cpu cortex-a7
.fpu neon-vfpv4

.data
	fpin:	.asciz "rainbow2.bmp"
	fpout:  .asciz "rainbow_out.bmp"
	rb:	.asciz "rb"
	wb: 	.asciz "wb"
	message: .asciz "The quick brown fox jumps over the lazy dog"

.text
.align 2
.global main
.type main, %function
.global encode
.type encode, %function

main:
	push {fp, lr}
	add fp, sp, #4

	@fopen("rainbow2.bmp", "rb")
	ldr r0, =fpin
	ldr r1, =rb
	bl fopen
	push {r0} 		@fpin stored in stack [fp, #-8]
	
	@fopen("rainbow_out.bmp", "wb");
	ldr r0, =fpout
	ldr r1, =wb
	bl fopen
	push {r0}		@fpout stored in stack [fp, #-12]

	@filesize = read_int(fpin, 2);
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #2		@r1 = 2 for args
	bl read_int		@call read_int(fpin, 2)
	push {r0}		@store filesize in stack [fp, #-16]

	@offset = read_int(fpin, 10);
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #10		@r1 = 10 for args
	bl read_int		@call read_int(fpin,10)
	push {r0}		@store offset in stack [fp, #-20]

    	@width = read_int(fpin, 18);
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #18		@r1 = 18 for args
	bl read_int		@call read_int(fpin, 12)
	push {r0}		@store width in stack [fp, #-24]

    	@height = read_int(fpin, 22);
	ldr r0, [fp, #-8]	@load fpin into r0
	mov r1, #22		@r1 = 22 for args
	bl read_int		@call read_int(fpin, 22)
	push {r0}		@store height in stack [fp, #-28]

	@fseek(fpin, offset, SEEK_SET);
	ldr r0, [fp, #-8]	@load fpin into r0 for args
	ldr r1, [fp, #-20]	@load offset into r1 for args 
	mov r2, #0		@load SEEK_SET into r2 for args
	bl fseek		
	
	@if ((3*width)%4 != 0)
	ldr r0, [fp, #-24]	@load width into r0
	mov r1, #3
	mul r0, r0, r1		@(3*width) stored in r0
	mov r1, #4		@r1 = 4 to call modulo
	bl modulo		@(3*width)%4 stored in r0
	mov r3, r0		@(3*width)%4 stored in r3 for comparison

	@if (3*width)%4 == 0
	cmp r3, #0
	beq initalize
	bne calculate
	
	initalize:
		@padding = 0 in this case
		mov r0, #0
		push {r0}	@store padding in stack [fp, #-32]
		b encode

	calculate:
		@padding = (3*width) % 4;
        	@padding = 4 - padding
		@(3*width) % 4 stored in r3
		mov r0, #4
		sub r0, r0, r3
		push {r0}	@store padding in stack [fp, #-32]
		b encode

encode:
	@B = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-24]	@load width into r1
	ldr r2,	[fp, #-28]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc		@malloc(width*height)
	push {r0}		@store B in stack [fp, #-36]

	@G = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-24]	@load width into r1
	ldr r2,	[fp, #-28]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc		@malloc(width*height)
	push {r0}		@store G in stack [fp, #-40]

	@R = (unsigned char *) malloc(width*height)
	ldr r1, [fp, #-24]	@load width into r1
	ldr r2,	[fp, #-28]	@load height into r2
	mul r0, r1, r2		@r0 = width*height for args
	bl malloc		@malloc(width*height)
	push {r0}		@store R in stack [fp, #-44]
	
	@read_image(fpin, B, G, R, height, width, padding)
	@r0 = fpin, r1 = B, r2 = G, r3 = R, rest on stack
	ldr r0, [fp, #-8]	@fpin
	ldr r1, [fp, #-36]	@B
	ldr r2, [fp, #-40]	@G
	ldr r3, [fp, #-44]	@R
	
	@store rest of args on stack pushing right to left
	ldr r4, [fp, #-32] 	@padding
	push {r4}
	ldr r4, [fp, #-24] 	@width
	push {r4}
	ldr r4, [fp, #-28] 	@height
	push {r4}
	@ready to call
	bl read_image

	@call to encode the image
	@encode_image(B, G, R, height, width, message)
	@r0 = B, r1 = G, r2 = R, r3 = height
	@rest need to be pushed right to left on stack
	ldr r0, =message	@message
	push {r0}		
	ldr r0, [fp, #-24] 	@width
	push {r0}
	ldr r0, [fp, #-36]	@B
	ldr r1, [fp, #-40]	@G
	ldr r2, [fp, #-44]	@R
	ldr r3, [fp, #-28]	@height
	@ready to call
	@bl encodeHiddenMessage
	bl encode_image

	@write_image(fpin, B, G, R, height, width, padding, fpout, offset)
	@r0 = fpin, r1 = B, r2 = G, r3 = R
	@rest need to be pushed right to left onto stack
	ldr r0, [fp, #-20]	@offset
	push {r0}
	ldr r0, [fp, #-12]	@fpout
	push {r0}
	ldr r0, [fp, #-32]	@padding
	push {r0}
	ldr r0, [fp, #-24]	@width
	push {r0}
	ldr r0, [fp, #-28]	@height
	push {r0}
	ldr r0, [fp, #-8]	@r0 = fpin
	ldr r1, [fp, #-36]	@r1 = B
	ldr r2, [fp, #-40]	@r2 = G
	ldr r3, [fp, #-44]	@r2 = R
	@ready to call
	bl write_image

	@fclose(fpin)
	ldr r0, [fp, #-8]
	bl fclose

	@fclose(fpout)
	ldr r0, [fp, #-12]
	bl fclose

	@return 0
	mov r0, #0
	sub sp, fp, #4
	pop {fp, pc}
