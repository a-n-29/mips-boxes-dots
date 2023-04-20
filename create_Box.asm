# Garrett McGinn, GLM200002 

# create_Box function: checks all boxes with loops and sees if any are empty
# then, it replaces the center of those boxes with the current player's Initial, U for User, or C for Computer
# finally, it adds either 1 or two points to that players score, a global variable, and returns player turn as the same
# if a box was not created, it returns the opposite player's turn
.data

#boxCenterCoord1:.word 0
#boxCenterCoord2:.word 0

.text

.globl create_Box

create_Box:
# preserves original $a0 on stack using stack pointer
addi $sp, $sp, -4
sw $a0, ($sp)

# saves the opposite current turn; if a box is found, it is changed back
lw $t7, current_Turn
addi $t7, $t7, 1
andi $t7, $t7, 1

# load array address
move $t0, $s0 # $t0 = grid array address

# load starting box index
addi $t1, $zero, 17
addi $t2, $zero, 1

# loops through each column that has a box center
loopThroughBoxRow:
	bgt $t1, 220, exitLoop
	
	# loops through each row that has a box center
	loopThroughBoxCol:
		bgt $t2, 16, exitRowLoop
	
		add $t3, $t2, $t1 # add coordinates to get current one
		
		# branches if box is not empty
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		lb $t5, ($t4)   # load the current element, $t5 = character that could be space or another character
		
		# Branch if there is a character already present (already filled box)
		bne $t5, ' ', exitColLoop
		
		# if still here, there might be a box, check all sides
		
		# top line check
		add $t3, $t3, -17 # set coordinates to top line
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		lb $t5, ($t4)   # load the current element, $t5 = character that could be space or another character
		beq $t5, ' ', exitColLoop # branch if there if isn't a line already present (invalid box)
		
		# left line check
		add $t3, $t3, 16 # set coordinates to left line
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		lb $t5, ($t4)   # load the current element, $t5 = character that could be space or another character
		beq $t5, ' ', exitColLoop # branch if there if isn't a line already present (invalid box)
		
		# right line check
		add $t3, $t3, 2 # set coordinates to right line
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		lb $t5, ($t4)   # load the current element, $t5 = character that could be space or another character
		beq $t5, ' ', exitColLoop # branch if there if isn't a line already present (invalid box)
		
		# bottom line check
		add $t3, $t3, 16 # set coordinates to bottom line
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		lb $t5, ($t4)   # load the current element, $t5 = character that could be space or another character
		beq $t5, ' ', exitColLoop # branch if there if isn't a line already present (invalid box)
		
		# if still here, there is a box that needs filling, keep turn, add points, and fill
		
		# box has been found, save currentTurn as the same turn it was
		lw $t7, current_Turn
		
		# add points and box character for current turn holder
		beq $t7, 0, computerPoints
		
		# User gets points and the square
		
		# add point
		lw $t3, user_Score
		addi $t3, $t3, 1
		sw $t3, user_Score
		
		add $t3, $t2, $t1 # add coordinates to get current one
		
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		li $t5, 'U' # load $t5 with character byte
		sb $t5, ($t4)   # save the current element to the array

		j exitColLoop
		
		# computer gets points and the square
		computerPoints: 
		
		# add point
		lw $t3, computer_Score
		addi $t3, $t3, 1
		sw $t3, computer_Score
		
		add $t3, $t2, $t1 # add coordinates to get current one
		
		sll $t4, $t3, 0   # calculate the byte offset of the current element to be moved
		add $t4, $t4, $t0   # add the byte offset to the base address of the array
		li $t5, 'C' # load $t5 with character byte
		sb $t5, ($t4)   # save the current element to the array
		
		exitColLoop:
		
		add $t2, $t2, 2
		
		j loopThroughBoxCol
		
	exitRowLoop:
		
	add $t1, $t1, 34
	add $t2, $zero, 1
	
	j loopThroughBoxRow

exitLoop:

# saves currentTurn
sw $t7, current_Turn

# restores $a0 to original value from the stack
lw      $a0, ($sp)
addi    $sp, $sp, 4

# return
jr      $ra