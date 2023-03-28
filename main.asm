.data
.text
.globl main
main:
	jal print_board
	jal user_Turn
exit:	li $v0, 10
	syscall

