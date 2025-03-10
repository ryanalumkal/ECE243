.global _start
_start:
	
	la t0, 0xff200000
	la t1, 0xff200050
	
	li s1, 0 #sum
	li s2, 0 #check if KEY_3 is pressed
	
	wait_loop: lw a0, (t1)
	andi a0, a0, 0b1111
	beqz a0, wait_loop
	
	edge_loop: lw a1, (t1)
	xor a1, a1, a0
	bne a1, a0, edge_loop
	
	key_check: li s10, 0b0001
	beq s2, s10, KEY_RESET
	beq a0, s10, KEY_0
	li s10, 0b0010
	beq a0, s10, KEY_1
	li s10, 0b0100
	beq a0, s10, KEY_2
	li s10, 0b1000
	beq a0, s10, KEY_3
	
	KEY_0: li s1, 1
	sw s1, (t0)
	j wait_loop
	
	KEY_1: li s10, 15
	beq s1, s10, wait_loop
	addi s1, s1, 1
	sw s1, (t0)
	j wait_loop
	
	KEY_2: li s10, 1
	beq s1, s10, wait_loop
	sub s1, s1, s10
	sw s1, (t0)
	j wait_loop
	
	KEY_3: li s1, 0
	sw s1, (t0)
	xori s2, s2, 1
	j wait_loop
	
	KEY_RESET: li s1, 1
	sw s1, (t0)
	xori s2, s2, 1
	j wait_loop
	