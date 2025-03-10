.global _start
_start:
	
	la a0, InputWord
	lw a1, 0x0(a0)
	
	li a2, 0
	
	loop: beqz a1, end
	andi a3, a1, 1
	add a2, a2, a3
	srli a1, a1, 1
	j loop
	
	end: la a0, Answer
	sw a2, (a0)
	
	stop: j stop

.data 
InputWord: .word 0x4a01fead

Answer: .word 0