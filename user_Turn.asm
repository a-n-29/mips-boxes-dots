# Elizabeth Cadungog, EMC200002

## RETURNS TWO VALUES ##
#	$v0 = row index
#	$v1 = col index

.data
	turnStart: .asciiz "\nUSER TURN"
	rowPrompt: .asciiz "\nEnter a valid row number (1 - 13): "	
	colPrompt: .asciiz "Enter a valid column number (1 - 17): "
	
	evenCol: .asciiz "\tPlease enter an even # column.\n"
	oddCol: .asciiz "\tPlease enter an odd # column.\n"
	
	displayVal: .asciiz "\tYou entered ("
	d2: .asciiz ","
	d3: .asciiz ")\n"
	
	rowNum: .word 0		# ranges 1 - 13 for user	# index 0 - 12
	colNum: .word 0		# ranges 1 - 17 for user	# index 0 - 16

	rowLength: .word 17	# each row has a width of 17
	invalidStr: .asciiz "The given-coordinate already has a line. Please enter another value.\n"
.text

.globl user_Turn

user_Turn:
	# preserves original $a0 on stack using stack pointer
	addi    $sp, $sp, -4
	sw      $a0, ($sp)
	
	li      $v0, 4
	la	$t5, turnStart	# loads address of turnStart to $t5
	move    $a0, $t5	# moves address of turnStart into $a0
	syscall
	
	getRow:	# prompt the user to enter a row number. Loops if invalid input given.
		li      $v0, 4
		la	$t5, rowPrompt	# loads address of rowPrompt to $t5
		move    $a0, $t5	# moves address of rowPrompt into $a0
		syscall
	
		# read rowNum from user
		li	$v0, 5		# sysCall to read int from user
		syscall 		# stores user-int in $v0
		# store rowNum
  	  	sw 	$v0, rowNum 	# stores rowNum as 32-bits in memory
  	  	lw	$t0, rowNum	# loads rowNum into $t0
	
		# check validity of row		# rowNum > 0	and	rowNum < 14
		li	$t1, 1		# if rowNum < 1, jump to getRow
		blt	$t0, $t1, getRow
		li	$t1, 13		# if rowNum > 13, jump to getRow
		bgt	$t0, $t1, getRow
		
		# else, given row is valid. Continue.
	
	getCol:	# prompt the user to enter a col number. Loops if invalid input given.
		li      $v0, 4
		la	$t5, colPrompt	# loads address of colPrompt to $t5
		move    $a0, $t5	# moves address of colPrompt into $a0
		syscall
	
		# read colNum from user
		li	$v0, 5		# sysCall to read int from user
		syscall 		# stores user-int in $v0
		# store colNum in memory
  	  	sw 	$v0, colNum 	# stores colNum as 32-bits in memory
  	  	lw	$t0, colNum	# loads colNum into $t0
	
		# check validity of col		# colNum > 0	and	colNum < 18
		li	$t1, 1		# if colNum < 1, jump to getRow
		blt	$t0, $t1, getCol
		li	$t1, 17		# if colNum > 17, jump to getRow
		bgt	$t0, $t1, getCol
		
		# check if colNum pairs with rowNum
			# HORIZONTAL: rowNum = odd, colNum = even	# VERTICAL: rowNum = even, colNum = odd
			# $t0 = colNum		$t1 = rowNum
		lw 	$t1, rowNum
		andi 	$t2, $t1, 1 		# if rowNum is even, $t2 = 0	# else rowNum is odd, $t2 = 1
		beq	$t2, $zero, evenRow	# $t2 = 0, rowNum is even. Jump to evenRow. Else, rowNum is odd.
		
	oddRow: # rowNum is odd, colNum must be even
		andi	$t2, $t0, 1		# if colNum is even, $t2 = 0	# else, colNum is odd, $t2 = 1
		beq	$t2, $zero, isValid
		
		# else, colNum is odd. Prompt for an even column and loop
		li      $v0, 4
		la	$t5, evenCol
		move    $a0, $t5
		syscall
		j getCol
		
	evenRow: # rowNum is even, colNum must be odd			
		andi	$t2, $t0, 1		# if colNum is even, $t2 = 0	# else colNum is odd, $t2 = 1
		bne	$t2, $zero, isValid
		
		# else, colNum is even. Prompt for an odd column and loop
		li      $v0, 4
		la	$t5, oddCol
		move    $a0, $t5
		syscall
		j getCol
	
isValid: # confirm that user-coordinate is valid, i.e. NOT a '+', '-', or '|'		
	move 	$t1, $s0		# $t1 = base-address of array
	lb	$t0, ($t1)		# get first byte of array

	# check for end of string
	beq 	$t0, $zero, getRow	# if end of string, prompt for input again
	
	# calculate index of user-coordinate
	# Index = (baseAddr) + actualColumn + (actualRow * rowLength)	
	lw	$t2, rowNum	# loads rowNum into $t2
	addi	$t2, $t2, -1		# gets actual rowNum
	lw	$t3, colNum	# loads colNum into $t3
	addi	$t3, $t3, -1		# gets actual colNum
	lw	$t4, rowLength	# loads rowLength into $t4
	mul	$t2, $t2, $t4	# $t2 = actualRow * rowLength
	add	$t5, $t3, $t2	# $t5 = offset = actualColumn + (actualRow * rowLength)
	
	# add offset to base address of array
	move 	$t0, $s0	# $t0 = address of array
	lb	$t1, ($t0)	# $t1 = first byte from array, index 0
	beq	$t1, $zero, getRow	# check if end of string, fixme (safety net, possibly remove)
	add	$t2, $t0, $t5	# index = baseAddress + offset
	lb	$t3, ($t2)	# load byte at given coordinate
	
	# $t3 = index within array for the user-given coordinate
	# check that the index is not already occupied with a '-' (odd row) or a '|' (even row)
 	lw 	$t1, rowNum
	andi 	$t2, $t1, 1 		# if rowNum is even, $t2 = 0	# else rowNum is odd, $t2 = 1
	
	# IF EVEN ROW, jump to check. ELSE ODD ROW, set $t1 = '-' before check.
	li 	$t0, '|'	# char to compare to for even rows
	beq	$t2, $zero, checkChar	# $t2 = 0, rowNum is even. Check for '|'.
	li 	$t0, '-'		# Else rowNum is odd, check for '-'
	
checkChar:		 	 	 	 	 	 	
	# check if char is a line
	bne 	$t3, $t0, turn_End	# VALID: jump to exit if the char is not already a line
					# else, INVALID: print error message and loop for input
	# print invalid input string
	li      $v0, 4
	la	$t5, invalidStr		
	move    $a0, $t5
	syscall
	j 	getRow
					
turn_End:
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
		# $t0 = rowNum, $t1 = colNum
 		lw	$t0, rowNum
 		lw	$t1, colNum
 		# subtract 1 from both values
 		addi	$t0, $t0, -1
 		addi	$t1, $t1, -1
 		# $v0 = rowNum - 1, $v1 = colNum - 1								
 		add	$v0, $t0, $zero
 		add	$v1, $t1, $zero
 																		
	# restores $a0 to original value from the stack
	lw      $a0, ($sp)
	addi    $sp, $sp, 4
	
	# return
	jr      $ra


####################
# 8 COLUMNS: 1 - 17
# 	Horizontal lines: even	
# 		- valid: 2, 4, 6, 8, 10, 12, 14, 16
# 	Vertical lines: odd
# 		- valid: 1, 3, 5, 7, 9, 11, 13, 15, 17

# 6 ROWS: 1 - 13
# 	Horizontal lines: odd
# 		- valid: 1, 3, 5, 7, 9, 11, 13
# 	Vertical lines: even
# 		- valid: 2, 4, 6, 8, 10, 12

# note: User views first row/col as index ‘1’. In Assembly, it is actually index ‘0’.

####################
