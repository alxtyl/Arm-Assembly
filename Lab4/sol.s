@ Define the Pi CPU
.cpu cortex-a53
.fpu neon-fp-armv8

.data
begin: .asciz "Generated Pile:\n"
startGame: .asciz "\nGame Starting!\n"
outp: .asciz "[%d] = "
outp2: .asciz "%d\n"
newLin: .asciz "\n"
endMsg: .asciz "Game finished!\n"

.text
.align 2
.global main
.type main, %function

main:
    push {fp, lr}
    add fp, sp, #4

    @ allocat a[45] for storage of up to 45 piles
    sub sp, sp, #180
    
    @ setting up from random num generation
    mov r0, #0
    bl time
    bl srand

    mov r4, #0   @ i counter
    mov r8, #45  @ total cards
    
    ldr r0, =begin
    bl printf
    
    b writeLoop
    
    mov r0, #0
    sub sp, fp, #4
    pop {fp, lr}

writeLoop: @ writing random piles into the array
    cmp r8, #0
    ble reset

    mov r0, #1
    mov r1, r8
    bl random  @ random number --> r0

    @ calculate byte offset into array
    mov r2, #4
    mul r2, r2, r4    @ i*4 bytes
    str r0, [sp, r2]  @ sp[r4] = r0
    
    sub r8, r8, r0    @ subtract the num of piles by the current
                      @ currents random number to get the next range
                      @ of piles
    add r4, r4, #1    @ i++
    b writeLoop

reset: 
    mov r10, r4 @ number of piles = i
    mov r4, #0  @ i = 0

printLoop: @ display the current piles before the game starts
    cmp r4, r10 @ checking for end condtion
    beq gameStart
   
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
    
    add r4, r4, #1 @ i++
    b printLoop
    
gameStart: @ displays start message
    ldr r0, =startGame
    bl printf
    
    b playRound

playRound: @ starts a round and resets the i counter
    mov r4, #0 @ i = 0
    b reducePile
    
reducePile: @ reduces a pile by 1 and then loads it back into 
            @ the array
    @ comapre i to num of piles
    cmp r4, r10 
    bge addPile
   
    @ subbing a[i] by one and returning it
    mov r2, #4
    mul r2, r2, r4
    
    ldr r1, [sp, r2] @ load a[i]
    sub r1, r1, #1   @ a[i] = a[i]--
    str r1, [sp, r2] @ store a[i]--
   
    add r4, r4, #1   @ i++
    b reducePile
    
addPile: @ adds a pile equal to the number of piles
    mov r2, #4
    mul r2, r2, r4
    str r4, [sp, r2] @ a[i] = i (where i is the num of piles)
    
    add r10, r10, #1 @ i++
    
    mov r4, #0 @ i = 0
    b srtArr
    
rmZeros: @ removes the zeros from pile
    mov r2, #4
    mul r2, r2, r4
    ldr r8, [sp, r2]
    
    cmp r8, #0    @ if a[i] == 0, shift pile over
    beq shiftPile
    
    cmp r8, #0    @ if a[i] > 0, shift is no longer needed
    bgt doneShift
    
    shiftPile:
        mov r9, r4      
        add r9, r9, #1 @ r9 = i++
        cmp r9, r10    @ if r9 => num of piles, reset i and
                       @ piles--
        bge reduceSize
        
        mov r2, #4     
        mul r2, r2, r9 
        ldr r12, [sp, r2] @ access a[i++]
        
        mov r2, #4
        mul r2, r2, r4
        str r12, [sp, r2] @ store a[i++] in a[i]
        add r4, r4, #1    @ i++
        
        b shiftPile
        
    reduceSize:
        mov r4, #0
        sub r10, r10, #1 @ pile--
        
        b rmZeros
        
    doneShift:
        mov r4, #0 @ i = 0
        b printLoop2

srtArr:
    cmp r4, r10
    bge doneSort
    
    mov r9, r4
    add r9, r9, #1 @ (i + 1)++ counter
    
    loop: 
        cmp r9, r10
        bge doneLoop
        
        mov r2, #4
        mul r2, r2, r4
        ldr r7, [sp, r2]
        
        mov r2, #4
        mul r2, r2, r9
        ldr r8, [sp, r2]
        
        cmp r7, r8
        ble skip
        
        mov r2, #4
        mul r2, r2, r4
        str r8, [sp, r2]
        
        mov r2, #4
        mul r2, r2, r9
        str r7, [sp, r2]
        
        skip:  
            add r9, r9, #1
            b loop
            
    doneLoop:
        add r4, r4, #1
        b srtArr
        
    doneSort:
        mov r4, #0
        b rmZeros

printLoop2: @ prints out array after a round has been played
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
    
    add r4, r4, #1 @ i++
    b printLoop2
    
    donePrint:
        ldr r0, =newLin
        bl printf
        
        mov r4, #0 @ reset i
        b endGame
    
endGame: @ check to see if final pile has been reached
    mov r9, r4
    add r9, r9, #1
    
    cmp r4, r10
    beq done

    mov r2, #4
    mul r2, r2, r4
    ldr r1, [sp, r2]
    
    cmp r1, r9
    bne playRound  @ if a[i] != a[i] keep playing
    
    add r4, r4, #1 @ i++
    b endGame
      
done: @ displays end message and ends program
    ldr r0, =endMsg
    bl printf
 
    mov r0, #0 @ return 0
    sub sp, fp, #4
    pop {fp, lr}
