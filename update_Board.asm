#Brennan Pease, BCP220000 
#with additions from grid.asm for reprinting purposes

.data
Inform: .asciiz "\nUpdating Board...\n"
.globl update_Board
.text

update_Board:

# preserves original $a0 on stack using stack pointer
addi $sp, $sp, -4
sw $a0, ($sp)

 # calculate the index of the array where the character should be inserted
add $t0, $v0, $zero # $t0 = rowNum 
mul $t0, $t0, 17 # $t0 = rowNum * 17
add $t0, $t0, $v1 # $t0 = rowNum * 17 + colNum

# $t0 is now the current index in the 1D array

# lines would be horizontal on an even colNum, and vertical on an odd colNum
andi $t2, $v0, 1 # $t2 would be 0 if even colNum, 1 if odd

# branch if colNum is odd
beq $t2, 1, verticalLine

# else, horizontal line:
li $t1, '-' 
j skipVLine

verticalLine:
li $t1, '|' 

skipVLine:

# load array address
move $t2, $s0 # $t0 = grid array address

# branches if box is not empty
sll $t4, $t0, 0   # calculate the byte offset of the current element to be added
add $t4, $t4, $t2   # add the byte offset to the base address of the array
sb $t1, ($t4)   # load the current element, $t1 = line

# restores $a0 to original value from the stack
lw      $a0, ($sp)
addi    $sp, $sp, 4

jr      $ra
