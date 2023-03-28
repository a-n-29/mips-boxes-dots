#################### Elizabeth Cadungog, EMC200002
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

## RETURNS TWO VALUES ##
#	$v0 = row index
#	$v1 = col index

.data
	turnStart: .asciiz "USER TURN"
	rowPrompt: .asciiz "\n\tEnter a valid row number (1 - 13): "	
	colPrompt: .asciiz "\tEnter a valid column number (1 - 17): "
	
	evenCol: .asciiz "\tPlease enter an even # column.\n"
	oddCol: .asciiz "\tPlease enter an odd # column.\n"
	
	displayVal: .asciiz "\tYou entered ("
	d2: .asciiz ","
	d3: .asciiz ")"
	
	rowNum: .word 0		# ranges 1 - 13 for user	# index 0 - 12
	colNum: .word 0		# ranges 1 - 17 for user	# index 0 - 16

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
		beq	$t2, $zero, turn_End	# $t2 = 0, colNum is even. Jump to turn_End
		
		# else, colNum is odd. Prompt for an even column and loop
		li      $v0, 4
		la	$t5, evenCol
		move    $a0, $t5
		syscall
		j getCol
		
	evenRow: # rowNum is even, colNum must be odd			
		andi	$t2, $t0, 1		# if colNum is even, $t2 = 0	# else colNum is odd, $t2 = 1
		bne	$t2, $zero, turn_End	# $t2 = 1, colNum is odd. Jump to turn_End
		
		# else, colNum is even. Prompt for an odd column and loop
		li      $v0, 4
		la	$t5, oddCol
		move    $a0, $t5
		syscall
		j getCol
		
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
 		# $v0 = rowNum - 1, $v1 = colNUm - 1								
 		add	$v0, $t0, $zero
 		add	$v1, $t1, $zero
 																		
	# restores $a0 to original value from the stack
	lw      $a0, ($sp)
	addi    $sp, $sp, 4
	
	# return
	jr      $ra
