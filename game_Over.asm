#Brennan Pease, BCP220000 
#Detects if game over, if game over, then tell if the user or computer wins. If not, go back to user_Turn

.data
user_Wins: .asciiz "You win!"
computer_Wins: .asciiz  "Computer wins,"
tie_Msg: .asciiz  "It's a tie."
.globl game_Over
.text


# load array address
move $t0, $s0

game_Over:
    #Counter for C's
    li $t1, 0           
    #Counter for U's
    li $t2, 0           
    #Counter for white spaces
    li $t3, 0           

loop:
    # Load a byte from array into $t4
    lb $t4, 0($t0)      
    #If the end of the array is reached, check for winner or tie
    beqz $t4, check_end 
    #Increment array pointer
    addi $t0, $t0, 1    

    li $t5, 'C'
    li $t6, 'U'
    li $t7, ' '

    beq $t4, $t5, increment_C
    beq $t4, $t6, increment_U
    beq $t4, $t7, increment_space
    j loop

increment_C:
    #Increment C counter
    addi $t1, $t1, 1   
    j loop

increment_U:
    #Increment U counter
    addi $t2, $t2, 1    
    j loop

increment_space:
    #Increment white space counter
    addi $t3, $t3, 1    
    j loop

check_end:
    bgt $t3, 0, user_Turn

    blt $t1, $t2, U_wins
    bgt $t1, $t2, C_wins
    beq $t1, $t2, tie

U_wins:
    li $v0, 4
    la $a0, user_Wins
    syscall
    j exit

C_wins:
    li $v0, 4
    la $a0, computer_Wins 
    syscall
    j exit

tie:
    li $v0, 4
    la $a0, tie_Msg 
    syscall
    j exit
exit:
    li $v0, 10   
    syscall
