.global _start
_start:
	
	.equ DELAY, 25000000
	.equ BUTTON, 0xff200050
	.equ TIMER, 0xff202000
	
	li a0, TIMER
	sw x0, (a0) #reset TO in status (note: has to be first? Might be making RUN = 0 if it is placed after Control Register stuff)
	
	li a1, DELAY
	sw a1, 0x8(a0)
	srli a1, a1, 16
	sw a1, 0xC(a0) #set counter val (low and high) to DELAY
	
	li a1, 0b0110
	sw a1, 0x4(a0) #set START and CONT to 1
	
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
	j TIMER_WAIT
	j loop
	
	reset: li a0, 0
	j loop
	
	wait: lw t0, 0xC(a3)
	li t1, 0b1111
	sw t1, 0xC(a3)
	bnez t0, loop
	
	j wait
	
	TIMER_WAIT: li s10, TIMER
	lw t0, 0(s10)
	andi t0, t0, 1
	beqz t0, TIMER_WAIT
	sw x0, (s10)
	j loop