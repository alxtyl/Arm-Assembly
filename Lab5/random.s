.cpu cortex-a53
.fpu neon-fp-armv8

.data

.text
.align 2
.global random
.type random, %function

random:
   push {fp, lr}
   add fp, sp, #4

   push {r0}  @ push init number onto the stack
   push {r1}  @ push final number onto the stack

   bl rand  @ generates a number between 0 and 1
            @ the random number is stored in r0

   ldr r1, [sp] @ load the top of the stack into r1 (final number)
                @ don't pop the value because we need it later

   bl modulo  @ r0 % r1 -> r0

   pop {r1}  @ pop the final number off the stack

   mov r1, r0  @ store the modulo value into r1

   pop {r0} @ pops the next number on top of the stack (init number)
   add r1, r1, r0  @ rand()*final + init

   mov r0, r1  @ move the result into r0 for return

   sub sp, fp, #4
   pop {fp, pc}
