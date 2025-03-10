.global _start
_start:
	
	.equ DELAY, 500000
	.equ BUTTON, 0xff200050
	
	li a0, 0
	li a1, 255
	la a2, 0xff200000
	li a3, BUTTON
	
	loop: beq a0, a1, reset
	
	lw t0, 0xC(a3)
	li t1, 0b1111
	sw t1, 0xC(a3)
	bnez t0, wait
	
	addi a0, a0, 1
	sw a0, (a2)
	j DO_DELAY
	j loop
	
	reset: li a0, 0
	j loop
	
	wait: lw t0, 0xC(a3)
	li t1, 0b1111
	sw t1, 0xC(a3)
	bnez t0, loop
	
	j wait
	
	DO_DELAY: li s0, DELAY
	SUB_LOOP: addi s0, s0, -1
	bnez s0, SUB_LOOP
	j loop