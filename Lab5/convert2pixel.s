@convert2pixel.s
@Converts to pixel
@5/15/2020: Garrett Birch + Alex Tyler

@define processors
.cpu cortex-a7
.fpu neon-vfpv4

.data
.text
.align 2
.global convert2pixel
.type convert2pixel, %function

convert2pixel:
	push {fp, lr}
	add fp, sp, #4

	@r0 -> length, r1 -> len[3] (unsigned char)
	mov r7, r1	@ pointer to char array stored in r7
	mov r2, r0	@length stored in r2

	@byte1 = length % 256
	mov r0, r2
	mov r1, #256		
	bl modulo	@length % 256 stored in r0
	mov r8, r0	@byte1 stored in r8

	@len[0] = byte1
	strb r8, [r7]

	@byte2 = (length >> 8) % 256
	mov r0, r2
	mov r0, r0, LSL #8 @bitshift right 8
	mov r1, #256		
	bl modulo		@(length >> 8)% 256 stored in r0
	mov r9, r0 		@byte2 stored in r9

	@len[1] = byte2
	add r7, r7, #1
	strb r9, [r7]

	@byte3 = (length >> 16) % 256
	mov r0, r2
	mov r0, r0, LSL #16 	@bitshift right 16
	mov r1, #256
	bl modulo		@(length >> 16)% 256 stored in r0
	mov r10, r0		@byte3 stored in r10

	@len[2] = byte3
	mov r2, #8
	add r7, r7, #1
	strb r10, [r7]


	@return call
	sub sp, fp, #4
	pop {fp, pc}
