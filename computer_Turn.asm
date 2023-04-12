.data

validArray: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121, 123, 125, 127, 129, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219
validArraySize: .word 0

rowNum: .word 0		# index 1 - 13
colNum: .word 0		# index 1 - 17

turnStart: .asciiz "\nCOMP TURN"

displayVal: .asciiz "\tComputer Moved ("
	d2: .asciiz ","
	d3: .asciiz ")"

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

move $t0, $s0 # $t0 = grid array address
addi $t1, $zero, 1 # $t1 = grid array index incrementer; starts at 1, adds 2 each loop

move $t2, $zero # $t2 = valid array size counter
la $t3, validArray # $t3 = valid array address

# Build an array of all valid spaces and count the size
build_Valid_Array_Loop:
	bge $t1, 210, build_Valid_Array_Loop_Exit # Exit loop if over the max size of grid array
	
	sll $t4, $t1, 0   # calculate the byte offset of the current element to be moved
	add $t4, $t4, $t0   # add the byte offset to the base address of the array
	lb $t5, ($t4)   # load the current element, $t5 = character that could be space or a line
	
	# Branch if there is a line (invalid index)
	bne $t5, ' ', isLine

	sll $t4, $t2, 2 # calculate the byte offset of the current element to be moved
	add $t4, $t4, $t3 # add the byte offset to the base address of the array
	sw $t1, ($t4) # save the valid index to validArray
	
	# Increment the valid Array size counter
	addi $t2, $t2, 1
	
	isLine:
	
	addi $t1, $t1, 2  # increment the grid array index
	
	j build_Valid_Array_Loop

build_Valid_Array_Loop_Exit:

sw $t2, validArraySize # loads in validArraySize to $t0

# Checks if validArraySize = 0
beq $t2, 0, validArraySizeZeroExit

# Randomly choose from validArray using maximum of validArraySize
lw $a1, validArraySize  # Set $a1 to the max bound (validArraySize - 1)
li $v0, 42  # Syscall for random int with maximum. Range is 0 - 109 to start
syscall

# Subtract 1 from validArraySize
addi $t2, $t2, -1
# Store $t0 as validArraySize
sw $t2, validArraySize

# Correspond the random value to the index of validArray
la $t3, validArray # loads in validArraySize to $t0
move $t2, $a0     # puts the index in $t2
sll $t2, $t2, 2    # index * 4 for word
add $t1, $t3, $t2    # get address of ith location
lw $a0, 0($t1)

# Change index to row and column format
li $t3, 17 # Load 17 for division
div $a0, $t3

mfhi $t0 # row
mflo $t1 # column
# add 1 to both values
addi $t0, $t0, 1
addi $t1, $t1, 1
# save to num values
sw $t0, rowNum
sw $t1, colNum
    
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

validArraySizeZeroExit:

# restores $a0 to original value from the stack
lw      $a0, ($sp)
addi    $sp, $sp, 4

# return
jr      $ra
