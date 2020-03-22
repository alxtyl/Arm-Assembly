.cpu cortex-a53
.fpu neon-fp-armv8

.data
outp: .asciz "[%d] = "
outp2: .asciz "%d\n"

.text
.align 2
.global main
.type main, %function

main:
    push {fp, lr}
    add fp, sp, #4

    @ allocat a[45]
    sub sp, sp, #180
    
    mov r0, #0
    bl time
    bl srand
    
    @ getting number of piles
    mov r0, #1
    mov r1, #10
    bl random
    mov r7, r0

    mov r4, #0   @ i counter
    mov r8, #45  @ total cards

writeLoop:
    cmp r8, #0
    ble out_loop

    mov r0, #1
    mov r1, r8
    bl random  @ random number --> r0

    @ calculate byte offset into array
    mov r2, #4
    mul r2, r2, r4  @ i*4 bytes

    str r0, [sp, r2]  @ sp[r4] = r0
    
    sub r8, r8, r0
    add r4, r4, #1  @ i = i + 1
    b writeLoop

outLoop:
    mov r10, r4 @ i = new i for the next loop
    mov r4, #0  @ reset i counter

printLoop:
    cmp r4, r10
    bge playGame
   
    mov r1, r4
    ldr r0, =outp
    bl printf

    mov r2, #4
    mul r2, r2, r4
    ldr r1, [sp, r2]

    ldr r0, =outp2

    bl printf
    add r4, r4, #1
    b printLoop
    
playGame:
    mov r4, #0 @ interations = 0
    mov r5, r4 @ current size = 0
    


done:
    sub sp, fp, #4
    pop {fp, pc}

   




