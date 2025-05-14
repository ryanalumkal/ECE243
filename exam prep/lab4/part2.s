.global _start
_start:
	
	.equ LEDs, 0xff200000
	.equ SWITCHS, 0xff200050
	.equ COUNTER_DELAY, 500000
	
	la t1, LEDs
	la t2, SWITCHS
	
	li a0, 0
	li a1, 255
	li a2, 1
	
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
	
	DO_DELAY: la s0, COUNTER_DELAY
	SUB_LOOP: addi s0, s0, -1
				bnez s0, SUB_LOOP
				j loop		