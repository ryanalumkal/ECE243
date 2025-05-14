.global _start
_start:
	
	.equ LEDs, 0xff200000
	.equ SWITCHS, 0xff200050
	.equ TIMER, 0xff202000
	.equ COUNTER_DELAY, 25000000
	
	la t1, LEDs
	la t2, SWITCHS
	
	li a0, 0
	li a1, 255
	li a2, 1
	
	la s0, TIMER
	la s1, COUNTER_DELAY
	sw s1, 8(s0)
	srli s1, s1, 16
	sw s1, 12(s0)
	
	li s1, 0b0110
	sw s1, 4(s0)
	
	loop:
		lw t3, 12(t2)
		li a3, 0xF
		sw a3, 12(t2)
		and t3, t3, a3
		bnez t3, toggle
		beqz a2, loop
		
		if_not_pressed:
			bge a0, a1, reset
			addi a0, a0, 1
			sw a0, (t1)
			j DO_DELAY
		
		toggle: xori a2, a2, 1
		j loop
		
		reset: li a0, 0
			j loop	
	
	DO_DELAY: lw s1, 0(s0)
			andi s1, s1, 1
			beqz s1, DO_DELAY
			sw s1, 0(s0)
			j loop