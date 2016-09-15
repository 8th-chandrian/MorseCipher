.data

str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
str_return: .asciiz "Return: "

# keyIndex
keyIndex_header: .asciiz "\n\n********* keyIndex *********\n"
keyIndex_mcmsg: .asciiz "-."
			  
# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
	la $a0, 0(%reg)
	syscall 
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro

.macro print_space
	li $v0, 11
	li $a0, ' '
	syscall 
.end_macro

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro

.macro print_char_addr(%address)
	li $v0, 11
	lb $a0, %address
	syscall
.end_macro

.macro print_char_reg(%reg)
	li $v0, 11
	move $a0, %reg
	syscall
.end_macro

.text
.globl main

main:
	############################################
	# TEST CASE for keyIndex
	############################################
	print_string(keyIndex_header) 
	print_string(str_input)
	print_string(keyIndex_mcmsg)
	print_newline

	la $a0, keyIndex_mcmsg
	jal keyIndex

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline
	
	
	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
