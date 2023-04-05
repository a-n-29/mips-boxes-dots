.data
.text
.globl main
main:
	jal print_board
gameloop:
	# check gameover condition
	jal user_Turn
	# change turn
	# computer turn
	jal computer_Turn
	# j gameloop
exit:	li $v0, 10
	syscall

