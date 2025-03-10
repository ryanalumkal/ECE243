.global _start
_start:
	
	li s1, 0
	li x10, 30
	
	loop: beqz x10, endloop
	add s1, s1, x10
	addi x10, x10, -1
	j loop
	
	endloop: j endloop