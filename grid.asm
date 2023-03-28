.data
array: .asciiz  "+ + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +                 + + + + + + + + +"
column_axis: .asciiz "\t1\t2\t\3\t4\t5\t6\t7\t8\t9\t10\t11\t12\t13\t14\t15\t16\t17\n"
.text
.globl print_board

	# get user input
	
	# isValid (args from user input)
	# updateBoard_Player (args from user input)

print_board:
	li $t0, 0          # initialize counter to 0
	la $a0,column_axis
	li $v0, 4
	syscall
	li $v0, 1	
	li $a0, 1		#row axis counter
	syscall
	li $t5, 2	#row axis counter
	
	li $v0, 11		#print \t system call
	li $a0, 9
	syscall
  
print_board_loop:
	lb $t1, array($t0) # load current character into $t1
	beq $t1, 0, exit    # if character is null terminator, exit print_board_loop
	addi $t0, $t0, 1    # increment counter
	addi $t2, $t0, 1    # calculate next character index

	lb $t3, array($t2) # load next character into $t3
	li $v0, 11          # print character system call
	move $a0, $t1       # load current character into $a0
	syscall
	li $v0, 11          # print tab system call
	li $a0, 9
	syscall
	rem $t4, $t0, 17    # calculate reprint_boardder of counter divided by 17
	beq $t4, $0, print_board_newline # if reprint_boardder is 0, print print_board_newline
	j print_board_loop              # otherwise, continue print_board_looping
print_board_newline:
	li $v0, 11          # print \n system call
	li $a0, 10
	syscall
	bgt $t5, 13, print_board_loop		#stop before print excessive row number, beyond 13
	#print row number
	move $a0, $t5
	li $v0, 1
	syscall
	addi $t5, $t5, 1
	li $v0, 11          # print \t system call
	li $a0, 9
	syscall
	j print_board_loop              # continue print_board_looping
exit:
	li $v0, 10          # exit program system call
	syscall

#	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17
#1	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#2	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#3	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#4	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#5	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#6	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#7	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#8	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#9	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#10	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#11	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
#12	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	
#13	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	 	+	
