#Brennan Pease, BCP220000 
#with additions from grid.asm for reprinting purposes

.data
array: .asciiz  "+ + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +"
Inform: .asciiz "\nUpdating Board...\n"
column_axis: .asciiz "\t1\t2\t3\t4\t5\t6\t7\t8\t9\t10\t11\t12\t13\t14\t15\t16\t17\n"
.globl update_Board
.text

update_Board:

 # Calculate the index of the array where the character should be inserted
    add $v0, $v0, 1  # row_index +1
    mul $t0, $v0, 17   # row_index * 17
    add $v1, $v1, 1  # column_index +1
    add $t0, $t0, $v1  # (row_index * 17) + col_index
    
   
    
    # Check row value (modulo 2) and store the character to be inserted in $t1
    rem $t2, $v0, 2
    # If modulo 2 == 0, then go to even_column
    beqz $t2, even_column
    li $t1, '|'
    j insert_character
even_column:
    li $t1, '-'


insert_character:
    # Insert the character into the array
    #load address of the array into $t3
    la $t3, array
    #add $t3 and $t0 and store in $t3
    add $t4, $t3, $t0
    # store | or - at the address of the array
    sb  $t1, 0($t4)
    
print_board:
    
    # Print the updated board
    la $a0, Inform
    li $v0, 4
    syscall

    # Print column numbers
    #Initialize counter to 0
    li $t0, 0          
    la $a0, column_axis
    li $v0, 4
    syscall
    li $v0, 1  
    #Row axis counter
    li $a0, 1      
    syscall
    #Row axis counter
    li $t5, 2          

    #Print tabs
    li $v0, 11         
    li $a0, 9
    syscall


update_board_loop:
    #Load current character into $t1
    lb $t1, 0($t3)
    #If character is null terminator, exit
    beq $t1, 0, endUpdateBoard   
    #Increment counter 
    addi $t0, $t0, 1  
    #Increment $t3  
    addi $t3, $t3, 1

    #Print character system call
    li $v0, 11      
    #Load current character into $a0    
    move $a0, $t1       
    syscall
    #Print tab system call
    li $v0, 11         
    li $a0, 9
    syscall
    #Calculate remainder of counter divided by 17
    rem $t4, $t0, 17    
    #If remainder is 0, print newline
    beq $t4, 0, update_board_newline 
    #Otherwise, continue looping
    j update_board_loop             

update_board_newline:
    #Print newline system call
    li $v0, 11          
    li $a0, 10
    syscall
    #Stop before printing excessive row number, beyond 13
    bgt $t5, 13, update_board_loop  
    #print row number
    move $a0, $t5
    li $v0, 1
    syscall
    addi $t5, $t5, 1
    #Print tab system call
    li $v0, 11          
    li $a0, 9
    syscall
    #Continue looping
    j update_board_loop              


endUpdateBoard:
    jal user_Turn
