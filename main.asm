# Anh Nguyen, Elizabeth Cadungog, Garrett McGinn, Brennan Pease 

.data

.globl current_Turn

user_Score: .word 0
computer_Score: .word 0
current_Turn: .word 1

.text
.globl main
main:
	#jal print_board
gameloop:

	# print the board
	jal print_board

	# check whose turn it is
	lw $t7, current_Turn
	bne $t7, 1, compGo
	
	# users turn
	jal user_Turn
	jal update_Board
	
	j boxCheck	# check if box needs to be created
	
compGo:
	# computer turn
	jal computer_Turn
	jal update_Board
		
boxCheck: 	
	# check if there is a box, otherwise change turn
	jal create_Box
	
	# check for game_Over
	# if grid is filled, game_Over will exit program
	jal game_Over
	
	j gameloop
	
	
exit:	li $v0, 10
	syscall

