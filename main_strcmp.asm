.data

str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
str_return: .asciiz "Return: "

# strcmp
strcmp_header: .asciiz "\n\n********* strcmp *********\n"
strcmp_str1: .asciiz "--x..x.--.x...xx..xx..-.x-.-.--xx"
strcmp_str2: .asciiz "--xxx..x.-x.xx-.x--x-xxx.xx-"
strcmp_size: .byte 3
			  
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
	# TEST CASE for strcmp
	############################################
	print_string(strcmp_header)
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str2)
	print_newline
	print_string(str_input)
	lb $t1, strcmp_size
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str2
	lb $a2, strcmp_size
	jal strcmp

	move $t0, $v0
	move $t1, $v1
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
