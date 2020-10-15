.cpu cortex-a53
.fpu neon-fp-armv8

.data
outp: .asciz "%d\n"

.text
.align 2
.global main
.type main, %function

main:

    push {fp, lr}
    add fp, sp, #4

    @ reset seed
    mov r0, #0
    bl time
    bl srand

    mov r4, #0  @ r4 = i
    mov r0, #10
    mov r0, r0, LSL #2

    bl malloc  @ r0 = malloc(10*4)

    mov r5, r0  @ store address of first memory location into r5

    loop:
        cmp r4, #10
        bge done_loop

        mov r0, #0
        mov r1, #100  @ generate random number between 0 and 100
        bl random

        @ a[r4] = r4]
        @ *(a + r4*4) = r0 that came from random
        mov r1, r4, LSL #2

        str r0, [r5, r1]

        add r4, r4, #1  @ i = i+1
    b loop

    done_loop:
        mov r4, #0
        
    loop2:
        cmp r4, #10
        bge done

        mov r1, r4, LSL #2
        ldr r1, [r5, r1]

        ldr r0, =outp

        bl printf
        add r4, r4, #1

    b loop2

    done:

        sub sp, fp, #4
        pop {fp, pc}

