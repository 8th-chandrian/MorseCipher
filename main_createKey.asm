.data

str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
str_return: .asciiz "Return: "

# createKey
createKey_header: .asciiz "\n\n********* createKey *********\n"
createKey_phrase: .asciiz "abcdefghijklmnOpqrstuvwxyz"
createKey_key: .space 26
			   .byte 0
			  
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
	# TEST CASE for createKey
	############################################
	print_string(createKey_header) 
	print_string(str_input)
	print_string(createKey_phrase)
	print_newline
	print_string(str_input)
	print_string(createKey_key)
	print_newline

	la $a0, createKey_phrase
	la $a1, createKey_key
	jal createKey

	print_string(str_result)
	print_string(createKey_key)
	print_newline
	
	
	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
