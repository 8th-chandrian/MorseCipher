##############################################################
# Homework #2
# name: Noah Young
# sbuid: 109960711
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	#Saves the return address and s0
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $ra, 4($sp)
	
	#Shifts every lowercase character to an uppercase character
	
	li $t0, 0 #t0 holds the character currently being processed
	la $s0, ($a0) #s0 holds the address of the first character in the string
	
	toUpperLoop:
		lb $t0, ($s0) #loads the character at s0 into t0
		beqz $t0, toUpperDone
		blt $t0, 'a', notLC	#Checks if the character is lowercase
		bgt $t0, 'z', notLC
		addi $t0, $t0, -32	#If so, decrements by 32 to get to the uppercase ascii value
		
		sb $t0, ($s0)	#Stores the uppercase ascii value into the byte address contained in s0
		
		notLC:
		addi $s0, $s0, 1	#Increments s0 to reference the next character in the string
		j toUpperLoop
		
	toUpperDone:
	
	#loads the return address and s0 and fixes the stack
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	#loads the word at address a0 into the return register
	la $v0, ($a0)
	jr $ra

length2Char:
	#Saves the return address and saved registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	
	#Gets the number of characters before the given character or the null terminator
	
	li $t0, 0 #t0 holds the character currently being processed
	la $s0, ($a0) #s0 holds the address of the first character in the string
	li $s1, 0 #s1 holds the number of characters before the given character
	lb $s2, ($a1) #s2 holds the character pointed to by the address in a1
	
	length2CharLoop:
		lb $t0, ($s0)	#load the character at s0 into t0
		beq $t0, $s2, length2CharDone 	#if t0 matches the stopping character or null, break from the loop
		beq $t0, $0, length2CharDone
		addi $s1, $s1, 1 #increment counter and address if not
		addi $s0, $s0, 1
		j length2CharLoop
	length2CharDone:
	la $v0, ($s1) #load the value at s1 into the return register
	
	#loads the return address and saved registers and fixes the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	jr $ra

strcmp:
	#Saves the return address and saved registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	la $s0, ($a0)	#s0 and s1 hold the addresses of the strings to check (these addresses will change as iteration occurs)
	la $s1, ($a1)
	li $s2, 0	#s2 holds the number of characters that matched
	la $s3, ($a2)	#s3 holds the number of characters to check
	li $t0, 0	#t0 and t1 hold the characters currently being checked
	li $t1, 0
	
	beqz $s3, compareAll
	bltz $s3, errorCMP
	bgtz $s3, compareLength
	
	
	compareAll: #If length equals zero, compare each character up to the newline reference
		lb $t0, ($s0)	#load characters being compared into t0 and t1
		lb $t1, ($s1)
		
		bne $t0, $t1, notEqualCA 	#If the characters aren't equal, break from the loop
		beqz $t0, equalCA		#If the characters both equal null, then the strings are equal; break from the loop
		
		addi $s0, $s0, 1	#Otherwise, increment addresses and the counter and loop again
		addi $s1, $s1, 1
		addi $s2, $s2, 1
		j compareAll
	
	notEqualCA:
	la $v0, ($s2) 	#loads the number of matching characters into v0 and 0 into v1, signifying that they did not match
	li $v1, 0
	j endCMP
	
	equalCA:
	la $v0, ($s2)	#loads the number of matching characters into v0 and 1 into v1, signifying that they matched
	li $v1, 1
	j endCMP
	
	
	compareLength:
		la $a0, ($s0)	#Get the length of the first string with length2Char
		la $a1, null_character
		jal length2Char
		la $t2, ($v0) 	#Loads the value at v0 (the first string's length) into t2
		bgt $s3, $t2, errorCMP	#If length is greater than the length of the first string, jump to error
		
		la $a0, ($s1)	#Get the length of the second string with length2Char
		la $a1, null_character
		jal length2Char
		la $t3, ($v0) 	#Loads the value at v0 (the second string's length) into t3
		bgt $s3, $t3, errorCMP	#If length is greater than the length of the second string, jump to error
		
		#--------- Now we know that both strings are greater in length than the given length ----------
		
		compareLengthLoop:
			lb $t0, ($s0)	#load characters being compared into t0 and t1
			lb $t1, ($s1)
		
			beq $s2, $s3, equalCL		#If the given length equals the counter, break from the loop
			bne $t0, $t1, notEqualCL 	#If the characters aren't equal, break from the loop
		
			addi $s0, $s0, 1	#Otherwise, increment addresses and the counter and loop again
			addi $s1, $s1, 1
			addi $s2, $s2, 1
			j compareLengthLoop
			
	notEqualCL:	#loads the number of matching characters into v0 and 0 into v1, signifying that they did not match
	la $v0, ($s2)
	li $v1, 0
	j endCMP
	
	equalCL:	#loads the number of matching characters into v0 and 1 into v1, signifying that they matched
	la $v0, ($s2)
	li $v1, 1
	j endCMP
		
	
	errorCMP: 	#Return 0,0 to signify an error
	li $v0, 0
	li $v1, 0
	
	endCMP:
	#loads the return address and saved registers and fixes the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	#Saves the return address and saved registers
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	
	la $s0, ($a0) 	#s0 will contain the address of the current character being converted
	la $s1, ($a1) 	#s1 will contain the address at which the morse code will be stored
	la $s2, ($a2) 	#s2 will contain the total number of bytes to store the morse code (not counting the null reference)
	addi $s2, $s2, -1
	li $s3, 0 	#s3 will contain the number of bytes used so far
	li $s5, 0	#s5 keeps track of whether or not the string is empty (1 for not empty, 0 for empty)
	li $s6, 0	#s6 keeps track of whether or not the morse code currently ends in "xx" (1 for ending in "xx", 0 for not)
	
	blez $s2, errorTM 	#if size is less than 1, return 0,0
	
	toMorseLoop:
		li $t0, 0
		lb $t0, ($s0) 	#load the current character being converted into t0
		
		beqz $t0, appendXXEnd	#If the current character is equal to null, try to add "xx" and terminate the function
		beq $t0, ' ', spaceChar	#If the current character is a space, add "xx"
		
		blt $t0, '!', ignoreChar	#if the current character is outside the bounds of the array, ignore it
		bgt $t0, 'Z', ignoreChar
		
		addi $t0, $t0, -33 	#get the array index of the given character (this will be the number of times we iterate through our loop)
		li $t1, 0	#t1 will contain our offset to get the correct word from the array
		li $t2, 0	#t2 will be our counter for the loop
		
		getOffsetLoop:
			beq $t2, $t0, offsetLoopDone
			addi $t1, $t1, 4	#increment t1 to reference the next word
			addi $t2, $t2, 1	#increment t2 to reference the next index
			j getOffsetLoop
		
		offsetLoopDone:
		li $s4, 0	#zero out s4
		lw $s4, MorseCode($t1) 	#load the given character's morse code sequence into s4, using the offset in t1
		
		beqz $s4, ignoreChar	#if the morse code sequence is null, ignore it
		
		la $a0, ($s4) 	#get the length of the given morse code sequence
		la $a1, null_character
		jal length2Char
		li $t3, 0
		la $t3, ($v0)	#load the length into t3
		
		li $t2, 0	#t2 will contain the counter for the loop
		
		addMorseCharLoop:
			beq $s2, $s3, notConvertedEnd	#if the given number of bytes are filled, jump to the end of the function
			beq $t3, $t2, morseCharLoopDone
			lb $t7, ($s4)
			sb $t7, ($s1)
			addi $s4, $s4, 1	#increment s4 to point to the next byte
			addi $s1, $s1, 1	#increment s1 to point to the next empty byte
			addi $s3, $s3, 1	#increment s3 to mark one more character being added
			addi $t2, $t2, 1	#increment the counter by 1
			j addMorseCharLoop
		morseCharLoopDone:
		
		li $s5, 1	#The string is not empty, so s5 should be 1
		li $s6, 0	#The string does not end with "xx", so s6 should be 0
		
		addi $s0, $s0, 1
		lb $t0, ($s0) 	#load the current character being converted into t0
		beqz $t0, noX
		beq $t0, ' ', noX
		blt $t0, '!', noX
		bgt $t0, 'Z', noX
		j addX
		noX:
		j toMorseLoop
			
			
	spaceChar:
		beqz $s5, doNothingSpaceChar	#If the string is currently empty, don't start the morse code with "xx"
		bnez $s6, doNothingSpaceChar	#If the string currently ends with "xx", don't add another "xx" to it
		beq $s2, $s3, notConvertedEnd
		
		lb $t7, x_character
		sb $t7, ($s1)
		addi $s1, $s1, 1	#increment address of s1 to point to the next empty byte, and s3 to mark one more character being added
		addi $s3, $s3, 1
		beq $s2, $s3, notConvertedEnd
		lb $t7, x_character
		sb $t7, ($s1)
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		
		li $s5, 1
		li $s6, 1
		
		doNothingSpaceChar:
		addi $s0, $s0, 1	#increment s0 to advance to the next character, and loop
		lb $t0, ($s0)
		
		#The only situation where we would add "xx" to an otherwise empty code string is if the next character was null
		
		bnez $t0, nextNotZero		
			bnez $s6, nextNotZero	#If the string currently ends with "xx", don't add another "xx" to it
			lb $t7, x_character	
			sb $t7, ($s1)
			addi $s1, $s1, 1	#increment address of s1 to point to the next empty byte, and s3 to mark one more character being added
			addi $s3, $s3, 1
			beq $s2, $s3, notConvertedEnd
			lb $t7, x_character
			sb $t7, ($s1)
			addi $s1, $s1, 1
			addi $s3, $s3, 1
			
			li $s5, 1
			li $s6, 1
		nextNotZero:
		j toMorseLoop
	
	ignoreChar:
		addi $s0, $s0, 1 #increment s0 to point to the next character, and loop
		lb $t0, ($s0) 	#load the current character being converted into t0
		bnez $s6, noX2
		beqz $t0, noX2
		beq $t0, ' ', noX2
		blt $t0, '!', noX2
		bgt $t0, 'Z', noX2
		j addX2
		noX2:
		j toMorseLoop
		
	addX:
		beq $s2, $s3, notConvertedEnd
		lb $t7, x_character		
		sb $t7, ($s1)
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		beq $s2, $s3, notConvertedEnd
		j noX
	
	addX2:
		beq $s2, $s3, notConvertedEnd
		lb $t7, x_character		
		sb $t7, ($s1)
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		beq $s2, $s3, notConvertedEnd
		j noX2
	
	appendXXEnd:
		beqz $s5, doNothingXXEnd	#If the string is empty, don't add "xx" to the end
		bnez $s6, doNothingXXEnd	#If the string already has "xx" at the end, don't add it again
		beq $s2, $s3, notConvertedEnd
		
		lb $t7, x_character
		sb $t7, ($s1)
		addi $s1, $s1, 1	#increment address of s1 to point to the next empty byte, and s3 to mark one more character being added
		addi $s3, $s3, 1
		beq $s2, $s3, notConvertedEnd
		lb $t7, x_character
		sb $t7, ($s1)
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		
		doNothingXXEnd:
		j convertedEnd	
	
	errorTM:	#Return 0,0 to signify an error
	li $v0, 0
	li $v1, 0
	j endTM
	
	notConvertedEnd:	#Return the number of bytes converted and 0 to signify that not all were converted
	lb $t7, null_character
	sb $t7, ($s1)	#load the null character as the last character of the converted morse code sequence
	addi $s3, $s3, 1
	la $v0, ($s3)
	li $v1, 0
	j endTM
	
	convertedEnd:	#Return the number of bytes converted and 1 to signify that the full string was converted
	lb $t7, null_character
	sb $t7, ($s1)	#load the null character as the last character of the converted morse code sequence
	addi $s3, $s3, 1
	la $v0, ($s3)
	li $v1, 1
	j endTM
	
	endTM:
	#loads the return address and saved registers and fixes the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra

createKey:
	#Saves the return address and saved registers
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	la $t4, ($a0)
	la $a0, ($t4)
	la $s1, ($a1)	#s1 will hold the address of the key being generated
	jal toUpper	#Convert the string in a0 to uppercase
	la $s0, ($v0)	#s0 will hold the address of the newly-converted uppercase string
	
	li $s2, 26	#s2 holds the size of alphabet array
	li $t0, 0	#t0 holds the counter when initializing the array to 0
	li $s3, '0'	#s4 will hold the '0' character
	li $s4, '1'	#s5 will hold the '1' character
	
	#First, make sure that every byte in alphabet_array is set to 0
	
	AlphaLoop:
		beq $s2, $t0, AlphaDone
		sb $s3, alphabet_array($t0)
		addi $t0, $t0, 1
		j AlphaLoop
	AlphaDone:
	
	#Then, iterate through each character in the uppercase string
	phraseLoop:
		lb $t1, ($s0)	#load the current character from the string
		beqz $t1, phraseLoopDone
		bgt $t1, 'Z', ignoreCharPhrase
		blt $t1, 'A', ignoreCharPhrase
		
		#If the character is an uppercase char, subtract 65 from it to get its location in the array
		li $t0, 0
		addi $t0, $t1, -65	#save its location in the array in t0
		lb $t2, alphabet_array($t0)
		
		#if the character has been set to 1 in the array, it has already been added and should be ignored
		beq $t2, $s4, ignoreCharPhrase
			sb $s4, alphabet_array($t0)	#Otherwise, set it to 1 and add the character to the key
			sb $t1, ($s1)
			addi $s1, $s1, 1	#increment s1 to reference the next empty byte
			
		ignoreCharPhrase:
		addi $s0, $s0, 1	#No matter what, increment s0 by 1 to get to the next character and loop
		j phraseLoop
	phraseLoopDone:
	
	#Once the loop terminates, iterate through the alphabet array
	
	li $t0, 0	#t0 will act as our counter again
	AlphaLoop2:
		beq $s2, $t0, AlphaDone2
		lb $t1, alphabet_array($t0)
		beq $t1, $s4, alreadyAdded	#If the character has been set to 1, it has already been added and should be ignored
			li $t2, 0
			addi $t2, $t0, 65	#Otherwise, add 65 to it to get the ascii value and add it to the key
			sb $t2, ($s1)
			addi $s1, $s1, 1
		alreadyAdded:	
		addi $t0, $t0, 1
		j AlphaLoop2
	AlphaDone2:
		
		
	endCK:
	#loads the return address and saved registers and fixes the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra

keyIndex:
	#Saves the return address and saved registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	la $s0, FMorseCipherArray	#s0 holds the current address of the array being checked
	li $s1, 26	#s1 holds the number of checks we will perform
	li $s2, 0	#s2 is the counter for the loop
	la $s3, ($a0)	#s3 holds the address of the morse string being checked
	
	indexArrayLoop:
	beq $s1, $s2, noMatchFound
		la $a0, ($s3)	#Params: the two strings being checked and the number of characters being checked (3)
		la $a1, ($s0)
		li $a2, 3
		jal strcmp	#Call strcmp
		
		la $t2, ($v1)		#load the output into t2 (1 if all compared characters match, 0 otherwise)
		bnez $t2, foundMatch	#If output is 1, match was found and loop terminates
		addi $s0, $s0, 3	#Otherwise, increment s0 by 3 and t1 by 1 and loop
		addi $s2, $s2, 1
		j indexArrayLoop
		
	foundMatch:
	la $v0, ($s2)	#If match is found, load the index of the match into v0
	j endKI
	
	noMatchFound:
	li $v0, -1	#if no match is found, load -1 into v0 to signify this
	
	endKI:
	#loads the return address and saved registers and fixes the stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra

FMCEncrypt:
	#Saves the return address and saved registers
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	
	la $s0, ($a0)	#s0 holds the address of the plaintext string being encrypted
	la $s1, ($a1)	#s1 holds the address of the phrase used to generate the key
	la $s2, ($a2)	#s2 holds the address of the buffer for the encrypted message (this is where the encrypted message
			#will be written to, and THIS SHOULD NOT CHANGE)
	la $s3, ($a3)	#s3 holds the size of the buffer
	addi $s3, $s3, -1	#Decrement s3 by 1 to account for the null character at the end
	
	#First, we call toMorse to get a morse code string for the function
	
	la $a0, ($s0)
	la $a1, morse_buffer	#the morse code will be held in morse_buffer
	li $a2, 800		#morse_buffer is 800 bytes in size		
	
	jal toMorse
	
	la $t0, ($v1)	#If string was entirely encoded, t0 will be 1. Otherwise it will be 0.
	
	beqz $t0, fmceError	#If t0 is 0, there was an error and the program should return -1 immediately
	
	#Next, we generate the key with createKey
	
	la $a0, ($s1)
	la $a1, key_buffer	#key will be held in key_buffer
	jal createKey
	
	#Finally, we loop through the morse code buffer and 
	
	li $s4, 0		#s4 will hold the counter for our address in morse_buffer
	la $s5, ($s2)		#s5 will hold the mutable address of the encrypt buffer (this is what we will increment)
	li $s6, 0		#s6 will hold the counter for our loop
	
	morseEncryptLoop:
		la $t3, morse_buffer($s4)
	
		lb $t0, 0($t3)	#Load the first three bytes into t0, t1, and t2
		lb $t1, 1($t3)
		lb $t2, 2($t3)
		
		beqz $t0, fmceEnd	#If any of the three bytes are null, we've reached the end of the string
		beqz $t1, fmceEnd	#Any remaining bytes are dropped, and we branch to the end of the function
		beqz $t2, fmceEnd
		
		beq $s6, $s3, fmceError		#If we've loaded "size" number of bytes into the buffer and there's still
						#at least one more to load, we've run out of space and should return an error
		
		la $a0, morse_buffer($s4)
		jal keyIndex
		
		la $t0, ($v0)	#Loads the key index of the character into t0, or -1 if there was no match
		beq $t0, -1, fmceError	#If t0 = -1, there was no match, and this should prompt an error
		
		lb $t1, key_buffer($t0)	#load the character in the key referenced by t0 into t1
		sb $t1, ($s5)
		
		addi $s4, $s4, 3	#increment s4 by 3 to move onto the next section of morse code, and s5 and s6 by 1 each
		addi $s5, $s5, 1
		addi $s6, $s6, 1
		j morseEncryptLoop
	
	fmceEnd:
	lb $t0, null_character	#Save the null character as the last byte in the array
	sb $t0, ($s5)
	la $v0, ($s2)
	li $v1, 1
	j endFMCE
	
	fmceError:
	lb $t0, null_character	#Save the null character as the last byte in the array
	sb $t0, ($s5)
	la $v0, ($s2)
	la $v1, -1
	
	#loads the return address and saved registers and fixes the stack
	endFMCE:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra



.data

MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"

null_character: .byte '\0'
x_character: .byte 'x'
alphabet_array: .space 26
morse_buffer: .space 800
key_buffer: .space 26