#tictactoe game
.data

#board
emptyrow: .asciiz "* * *"

	
#player_1_2_routine prompts
First_Player: .asciiz "\n\nPlayer 1, Enter a coordinate for your position (let row 1: 1 2 3 and row 2: 4 5 6 and row 3: 7 8 9): "
Second_Player: .asciiz "\n\nPlayer 2 (let row 1: 1 2 3 and row 2: 4 5 6 and row 3: 7 8 9): "
	
#Winning scenarios
player_1: .asciiz "\nCongratulations Player 1"
player_2: .asciiz "\nCongratulations Player 2"
tiegame: .asciiz "No winner"
	
#Characters
X: .byte 'X'
O: .byte 'O'
	
	
board: .word 10  #allocate space

.text

li $v0, 4
la $a0, emptyrow
syscall
jal EOL

li $v0, 4
la $a0, emptyrow
syscall
jal EOL

li $v0, 4
la $a0, emptyrow
syscall

#initialize
li $s6, 0
li $s7, 0
j player_1_2_routine



player_1_2_routine:
	beq $s6, 0, first_player_prompt 
	beq $s6, 1, second_player_prompt 


first_player_prompt:
	li $v0, 4
	la $a0, First_Player
	syscall
	beq $s7, 9, print_tie
	li $v0, 5 
	syscall
	li $s1, 0
	add $s1, $s1, $v0 
	la $t1, board  #board space
	add $t1, $t1, $s1 
	lb $t0, ($t1) 
	addi $s7, $s7, 1 
	la $t1, board 
	add $t1, $t1, $s1 
	bne $t0, 0, player_1_2_routine #check for duplicate
	li $t0, 1 
	sb $t0, ($t1) 
	li $s6, 1 
	j initialize_counters #check board for approriate_winning_player


initialize_counters:
	li $s4, 0 
	li $s3, 0 
	j EOL_2	

	#edit this routine	
approriate_winning_player_routine:
	beq $s4, 9, row_column_search 
	beq $s4, $s3, EOL_2
	addi $s4, $s4, 1 
	la $t0, board 
	add $t0, $t0, $s4  
	lb $t5, ($t0) 
	j print_char_routine
	

row_column_search:
	bge $s7, 5, check_column_1 	

second_player_prompt:
	li $v0, 4
	la $a0, Second_Player
	syscall
	beq $s7, 9, print_tie
	li $v0, 5 
	syscall
	li $s1, 0
	add $s1, $s1, $v0
	la $t1, board  
	add $t1, $t1, $s1 
	lb $t0, ($t1) 	
	addi $s7, $s7, 1 
	la $t1, board
	add $t1, $t1, $s1
	bne $t0, 0, player_1_2_routine 
	li $t0, 2
	sb $t0, ($t1)
	li $s6, 0 
	j initialize_counters

print_tie:
	li $v0, 4
	la $a0, tiegame
	syscall
	li $v0, 10
	syscall
	
#end of line
EOL:
	li $a0, 10 
	li $v0, 11 
	syscall
	jr $ra

EOL_2:
	addi $s3, $s3, 3 #eg increment then new line
	jal EOL
	j approriate_winning_player_routine 

	
#board characters
print_char_routine:
	beq $t5, 0, print_empty_spaces 
	beq $t5, 1, print_x 
	beq $t5, 2, print_o 

print_empty_spaces:
	li $v0, 11 
	li $a0, 0 
	syscall
	j approriate_winning_player_routine 

print_x:
	li $v0, 11 #print x
	lb $a0, X #load x
	syscall
	j approriate_winning_player_routine


print_o:
	li $v0, 11 #print O
	lb $a0, O #load O
	syscall
	j approriate_winning_player_routine



#print appropriate player
approriate_winning_player:
	beq $s2, 1, congrats_p1 
	beq $s2, 2, congrats_p2 

congrats_p1:
	li $v0, 4
	la $a0, player_1
	syscall
	li $v0, 10
	syscall
	
congrats_p2:
	li $v0, 4
	la $a0, player_2
	syscall
	li $v0, 10
	syscall	


#possible win scenarios
check_column_1:
	jal initialize
	lb $t5, ($t1)
	addi $t1, $t1, 3
	jal load_increment
	bne $t0, $t5, check_column_2
	bne $t5, $t4, check_column_2
	beq $t0, 0, check_column_2
	j approriate_winning_player
	
check_column_2:
	li $s0, 2
	jal initialize_set_2
	addi $t1, $t1, 3
	lb $t5, ($t1)
	addi $t1, $t1, 3
	jal load_increment_set_2
	bne $t0, $t5, check_column_3
	bne $t5, $t4, check_column_3
	beq $t0, 0, check_column_3
	j approriate_winning_player
	
check_column_3:
	li $s0, 3
	jal initialize_set_3
	addi $t1, $t1, 3
	lb $t5, ($t1)
	addi $t1, $t1, 3
	jal load_increment_set_3
	bne $t0, $t5, check_row_1
	bne $t5, $t4, check_row_1
	beq $t0, 0, check_row_1
	j approriate_winning_player
	
	
check_row_1:
	jal initialize
	addi $t1, $t1, 1 
	lb $t5, ($t1) 
	addi $t1, $t1, 1 
	jal load_increment
	bne $t0, $t5, check_row_2 
	bne $t5, $t4, check_row_2  
	beq $t0, 0, check_row_2 
	j approriate_winning_player 

check_row_2:
	li $s0, 4
	jal initialize_set_2
	addi $t1, $t1, 1
	lb $t5, ($t1)
	addi $t1, $t1, 1
	jal load_increment_set_2
	bne $t0, $t5, check_row_3
	bne $t5, $t4, check_row_3
	beq $t0, 0, check_row_3
	j approriate_winning_player

check_row_3:
	li $s0, 7
	jal initialize_set_3
	addi $t1, $t1, 1
	lb $t5, ($t1)
	addi $t1, $t1, 1
	jal load_increment_set_3
	bne $t0, $t5, check_diagonal_1
	bne $t5, $t4, check_diagonal_1
	beq $t0, 0, check_diagonal_1 
	j approriate_winning_player 

check_diagonal_1:
	jal initialize
	addi $t1, $t1, 4
	lb $t5, ($t1)
	addi $t1, $t1, 4
	jal load_increment
	bne $t0, $t5, check_diagonal_2
	bne $t5, $t4, check_diagonal_2
	beq $t0, 0, check_diagonal_2
	j approriate_winning_player

check_diagonal_2:
	li $s0, 3
	jal initialize_set_2
	addi $t1, $t1, 2
	lb $t5, ($t1)
	addi $t1, $t1, 2
	jal load_increment_set_2
	bne $t0, $t5, player_1_2_routine 
	bne $t5, $t4, player_1_2_routine 
	beq $t0, 0, player_1_2_routine 
	j approriate_winning_player

	
initialize:
	li $s2, 0 
	li $s0, 1 
	la $t1, board 
	add $t1, $t1, $s0 
	lb $t0, ($t1) #load value of position
	jr $ra
	
load_increment:
	lb $t4, ($t1) 
	add $s2, $s2, $t0
	jr $ra
	
initialize_set_2:
	li $s2, 0
	la $t1, board
	add $t1, $t1, $s0
	lb $t0, ($t1)
	jr $ra

load_increment_set_2:
	lb $t4, ($t1)
	add $s2, $s2, $t0
	jr $ra

initialize_set_3:
	li $s2, 0
	la $t1, board
	add $t1, $t1, $s0
	lb $t0, ($t1)
	jr $ra

load_increment_set_3:
	lb $t4, ($t1)
	add $s2, $s2, $t0
	jr $ra
	