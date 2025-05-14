.global _start
_start:
	
	li t0, 0
	li t1, 30
	li s1, 0
	
	for: bge t0, t1, loop
		addi t0, t0, 1
		add s1, s1, t0
		j for

	loop: j loop