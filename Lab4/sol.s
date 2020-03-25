@ Define the Pi CPU
.cpu cortex-a53
.fpu neon-fp-armv8

.data
begin: .asciz "Generated Pile:\n"
startGame: .asciz "\nGame Starting!\n"
outp: .asciz "[%d] = "
outp2: .asciz "%d\n"
dble: .asciz "\n\n"
gameOver: .asciz "Game finished!"

.text
.align 2
.global main
.global playRound
.global endGame
.type main, %function
.type playRound, %function
.type endGame, %function

main:
    @ program upkeep
    push {fp, lr}
	add fp, sp, #4

    @ allocat a[45] for storage of up to 45 piles
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
    
    ldr r0, =begin
    bl printf

writeLoop:
    cmp r8, #0
    ble reset

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

reset: 
    mov r10, r4 @ number of piles = i
    mov r4, #0  @ i = 0

printLoop:
    cmp r4, r10 @ checking for end condtion
    beq reset2
   
    @ print i
    mov r1, r4
    ldr r0, =outp
    bl printf

    @ array operations
    mov r2, #4
    mul r2, r2, r4
    ldr r1, [sp, r2]

    @ print a[i]
    ldr r0, =outp2
    bl printf
    
    add r4, r4, #1 @ uptick i
    b printLoop
    
reset2:
    mov r10, r4 @ number of piles = i
    mov r4, #0  @ reset counter i
    
    ldr r0, =startGame
    bl printf
    
    b playRound
    
playRound:
    mov r4, #0
    b reducePile
    
reducePile:
    @ comapre i to num of piles
    cmp r4, r10 
    bge addPile
   
    @ array operations
    @ a[i] = a[i] - 1
    mov r2, #4
    mul r2, r2, r4
    
    ldr r1, [sp, r2]
    sub r1, r1, #1
    str r1, [sp, r2]
   
    add r4, r4, #1 @ uptick i counter
    b reducePile
    
addPile:
    @ calculate byte offset into array
    mov r2, #4
    mul r2, r2, r4
    str r4, [sp, r2] @ a[i] = i
    
    add r10, r10, #1 @ uptick pile size
    
    b srtArr
    
rmZeros:
    mov r4, #0
    mov r11, r4
    
    traverse:  
        mov r2, #4
        mul r2, r2, r4
        ldr r9, [sp, r2]
        
        cmp r9, #0    @ if a[i] == 0, shift pile
        beq shiftPile
        
        cmp r9, #0    @ if a[i] > 0, shift is done
        bgt doneShift
        
        shiftPile:
            mov r11, r4
            add r11, r11, #1
            cmp r11, r10
            bgt reduceSize
            
            mov r2, #4
            mul r2, r2, r11
            ldr r12, [sp, r2]
            
            mov r2, #4
            mul r2, r2, r4
            str r12, [sp, r2]
            add r4, r4, #1
            
            b shiftPile
            
        reduceSize:
            mov r4, #0
            sub r10, r10, #1
            
            b traverse
            
    doneShift:
        b printLoop2

srtArr:
    mov r4, #0 @ i = 0
    
    mov r11, r4
    add r11, r11, #1
    
    loopi:
        cmp r4, r10
        bge doneSort
        
        mov r11, r4
        add r11, r11, #1
        
        loopj: 
            cmp r11, r10
            bge doneLoopj
            
            mov r2, #4
            mul r2, r2, r4
            ldr r7, [sp, r2]
            
            mov r2, #4
            mul r2, r2, r11
            ldr r8, [sp, r2]
            
            cmp r7, r8
            ble skip
            
            mov r2, #4
            mul r2, r2, r4
            str r8, [sp, r2]
            
            mov r2, #4
            mul r2, r2, r11
            str r7, [sp, r2]
            
            skip:  
                add r11, r11, #1
                b loopj
                
        doneLoopj:
            add r4, r4, #1
            b loopi
            
    doneSort:
        b rmZeros

printLoop2:
    mov r7, r0
    mov r4, #0
    mov r2, #4
    
    print:
        cmp r4, r10 @ checking for end condtion
        beq donePrint

        @ print i
        mov r1, r4
        ldr r0, =outp
        bl printf

        @ array operations
        mov r2, #4
        mul r2, r2, r4
        ldr r1, [sp, r2]

        @ print a[i]
        ldr r0, =outp2
        bl printf
        
        add r4, r4, #1 @ uptick i
        b print
    
    donePrint:
        mov r4, r7
    
        ldr r0, =dble
        bl printf
        
        b endGame
        
done:
	ldr r0, =gameOver
	bl printf
    
	sub sp, fp, #4
	pop {fp,lr}
    
endGame:
    mov r4, #0
    
    finTraverse:
        mov r11, r4
        add r11, r11, #1
        
        cmp r4, r10
        bge done
        
        mov r2, #4
        mul r2, r2, r4
        ldr r9, [sp, r2]
        
        cmp r11, r9
        bne playRound
        
        add r4, r4, #1
        b finTraverse

   




