####	Final Project
####	by Zachary Sonntag
####
####	__________________________________________________Introduction__________________________________________________
####	
####	This application will ask the user for 2 integer inputs in which the application will find the greatest common 
####	denominator (GCD) of the 2 integers and print out the result to the console.
####
####	To achieve the output, the Euclidean Algorithm will be used. This will be done by dividing the smallest integer
####	from the largest integer from the two inputs provided by the user. The remainder will then be used to divide from 
####	the previous divisor. This will continue until there is no more remainder, which the GCD will be the previous 
####	remainder.
####
####	All code should execute as expected. Code should be written neatly, be concise, and have proper documentation.


.data

####	Data should consist of user prompts/messaging, storage variables, and string formatting.

####	Start of user prompts/messaging/string formatting

#Welcome message.

	userWelcome: .asciiz "Welcome user, to the application! This application will prompt you for 2 whole positive numbers, in which it will output the greatest common divisor (GCD) of the values.\n"
	userWelcome2: .asciiz "This will be done using the Euclidean Algorithm!\n\n"
	
#User prompt messaging.

	userPrompt: .asciiz "Please type in the first positive, whole number. (WARNING: You MUST type in a POSITIVE, WHOLE number):\n"
	userPrompt2: .asciiz "\nPlease type in the second positive, whole number. (WARNING: You MUST type in a POSITIVE, WHOLE number):\n"
	
#GCD result messaging.
	
	resultMessage: .asciiz "\n\nThe GCD of your values "
	printAnd: .asciiz " and "
	printIs: .asciiz " is "

#Goodbye message.
	
	goodbyeMessage: .asciiz "\n\nThank you for using this application! Goodbye!"
	
####	End of user prompts/messaging/string formatting

####	Start of program variables

#User input variables.

	userInput: .word 0
	userInput2: .word 0
	
####	End of program variables


.text

#Main method
main:
	#Prompts welcome messages.
	li $v0, 4
	la $a0, userWelcome
	syscall
	
	li $v0, 4
	la $a0, userWelcome2
	syscall
	
	#Prompts user for first input value.
	li $v0, 4
	la $a0, userPrompt
	syscall
	
	#Requests integer from user input.
	li $v0, 5
	syscall
	
	#Moves the integer into register $t0.
	move $t0, $v0
	
	#Saves the integer into the variable userInput for later printing.
	sw $t0, userInput
	
	
	#Prompts user for the second input value.
	li $v0, 4
	la $a0, userPrompt2
	syscall
	
	#Requests integer from user input.
	li $v0, 5
	syscall
	
	#Moves the integer into register $t1.
	move $t1, $v0
	
	#Saves the integer into the variable userInput2 for later printing.
	sw $t1, userInput2
	
	
	#Calls the Euclidean method.
	jal euclidean
	
	#Resets the user input values to get ready to print.
	lw $t0, userInput
	lw $t1, userInput2
	
	#Result messaging series.
	li $v0, 4
	la $a0, resultMessage
	syscall
	
	#Prints first user input.
	li $v0, 1
	addi $a0, $t0, 0
	syscall
	
	#Prints and formatting.
	li $v0, 4
	la $a0, printAnd
	syscall
	
	#Prints second user input.
	li $v0, 1
	addi $a0, $t1, 0
	syscall
	
	#Prints is formatting.
	li $v0, 4
	la $a0, printIs
	syscall
	
	#Prints GCD result.
	li $v0, 1
	addi $a0, $v1, 0
	syscall
	
	#Initiates goodbye message.
	li $v0 4
	la $a0, goodbyeMessage
	syscall
	
	#Ends the program.
	li $v0, 10
	syscall
	
#This is the Euclidean Algorithm method.
euclidean:

	#Determines which value is lesser.
	slt $t3, $t0, $t1
	
	#Branches to else if $t0 is greater than $t1. If not greater, than switches the values so $t0 is greater.
	beq $t3, $zero, Else
	
	#Switches the values.
	lw $t0, userInput2
	lw $t1, userInput
	
	#Else continue if largest value is in $t0.
	Else:
	
	#Initiates LOOP tag - Else tag could be used for the LOOP, but is unconventional.
	LOOP:
	
	#Exits the loop if remainder is 0.
	beq $t1, $zero, DONE
	
	#Divides $t0/$t1 and puts the remainder in HI.
	div $t0, $t1
	
	#Stores $t1 into $t2 temporarily due to pipelining error.
	add $t2, $t1, $zero
	
	#Moves remainder into $t1.
	mfhi $t1
	
	#Moves original $t1 value into $t0.
	add $t0, $t2, $zero
	
	#Jumps back to LOOP tag.
	j LOOP
	
	#DONE tag to exit LOOP.
	DONE:
	
	#Stores the GCD into $v1, the return register.
	addi $v1, $t0, 0
	
	#Ends the method and jumps back up to where it was called.
	jr $ra
