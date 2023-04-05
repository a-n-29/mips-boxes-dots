# Current Computer Function: Randomly picks valid index

# TODO: Check the board to make sure a line isn't already there.
# TODO: Advanced function for checking if there are 3 lines so the computer can choose to form a box

## RETURNS TWO VALUES ##
#	$v0 = row index
#	$v1 = col index

.data
turnStart: .asciiz "COMP TURN"

	displayVal: .asciiz "\tComputer Moved ("
	d2: .asciiz ","
	d3: .asciiz ")"

rowNum: .word 0		# index 0 - 12
colNum: .word 0		# index 0 - 16

.text

.globl computer_Turn

computer_Turn:
# preserves original $a0 on stack using stack pointer
addi $sp, $sp, -4
sw $a0, ($sp)

li $v0, 4
la $t5, turnStart	# loads address of turnStart to $t5
move    $a0, $t5	# moves address of turnStart into $a0
syscall

# Randomly Decide on even or odd horizontal: (1 or 0)
li $a1, 1  # Set $a1 to the max bound (1)
li $v0, 42  # Syscall for random int with maximum.
syscall

# 50% chance to jump to label
beq $a0, 1, rowOdd 

rowEven:
# 	Valid Rows: even	
# 		- valid: 2, 4, 6, 8, 10, 12, 14, 16
# 	Valid Columns: odd
# 		- valid: 1, 3, 5, 7, 9, 11, 13

# Randomly generates valid row
li $a1, 7  # Set $a1 to the max bound, we will multiply it by 2, so it is half the valid lines (0 - 7)
li $v0, 42  # Syscall for random int with maximum.
syscall

addi $a0, $a0, 1  # Adds 1 so the range is now (1 - 8)
mul $a0, $a0, 2 # Multiplys by 2 so the range is now (2, 4, ..., 16) 

sw $a0, rowNum # Stores the rowNum

# Randomly generates valid column
li $a1, 6  # Set $a1 to the max bound, we will multiply it by 2, so it is half the valid range (0 - 6)
li $v0, 42  # Syscall for random int with maximum.
syscall

addi $a0, $a0, 1  # Adds 1 so the range is now (1 - 7)
mul $a0, $a0, 2 # Multiplys by 2 so the range is now (2, 4, ..., 14) 
addi $a0, $a0, -1  # Subtracts 1 so the range is now (1, 3, ..., 13)

sw $a0, colNum # Stores the colNum

j comp_Turn_End

rowOdd:
# 	Valid Rows: even	
# 		- valid: 1, 3, 5, 7, 9, 11, 13, 15, 17
# 	Valid Columns: odd
# 		- valid: 2, 4, 6, 8, 10, 12

# Randomly generates valid row
li $a1, 8  # Set $a1 to the max bound, we will multiply it by 2, so it is half the valid lines (0 - 8)
li $v0, 42  # Syscall for random int with maximum.
syscall

addi $a0, $a0, 1  # Adds 1 so the range is now (1 - 9)
mul $a0, $a0, 2 # Multiplys by 2 so the range is now (2, 4, ..., 18) 
addi $a0, $a0, -1  # Subtracts 1 so the range is now (1, 3, ..., 17)

sw $a0, rowNum # Stores the rowNum

# Randomly generates valid column
li $a1, 5  # Set $a1 to the max bound, we will multiply it by 2, so it is half the valid range (0 - 5)
li $v0, 42  # Syscall for random int with maximum.
syscall

addi $a0, $a0, 1  # Adds 1 so the range is now (1 - 6)
mul $a0, $a0, 2 # Multiplys by 2 so the range is now (2, 4, ..., 12) 

sw $a0, colNum # Stores the colNum

comp_Turn_End:

# display values entered by user
		# string 1/3
		li      $v0, 4
		la	$t5, displayVal		
		move    $a0, $t5
		syscall
		# print rowNum	
		lw 	$a0, rowNum
 		li 	$v0, 1
 		syscall 
 		#string 2/3
 		li      $v0, 4
		la	$t5, d2		
		move    $a0, $t5
		syscall
 		# print colNum	
		lw 	$a0, colNum
 		li 	$v0, 1
 		syscall 
 		# string 3/3
 		li      $v0, 4
		la	$t5, d3		
		move    $a0, $t5
		syscall

# modify values to match actual index, then store in registers $v0, $v1
# subtract 1 from both values
addi $t0, $t0, -1
addi $t1, $t1, -1
# $v0 = rowNum - 1, $v1 = colNum - 1								
add $v0, $t0, $zero
add $v1, $t1, $zero
	
# restores $a0 to original value from the stack
lw      $a0, ($sp)
addi    $sp, $sp, 4

# return
jr      $ra
