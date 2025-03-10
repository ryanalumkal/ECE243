.global _start
_start:
	
	li sp, 4000
	la a0, InputWord
	lw a1, 0x0(a0)
	li a0, 0
	call ONES
	
	j finish
	
	ONES:
		
		addi sp, sp, -4
		sw ra, 0(sp)
		
		loop: beqz a1, end
		andi a3, a1, 1
		add a0, a0, a3
		srli a1, a1, 1
		j loop
		
		end: lw ra, 0(sp)
		addi sp, sp, 4
		
		ret
	
	
	finish: la a1, Answer
	sw a0, (a1)
	
	stop: j stop

.data 
InputWord: .word 0x4a01fead

Answer: .word 0