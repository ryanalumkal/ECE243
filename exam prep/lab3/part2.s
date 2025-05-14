/* Program to Count the number of 1’s in a 32-bit word,
located at InputWord */
.global _start
_start:

/* Put your code here */
la sp, 20000
la t0, InputWord
lw a1, (t0)
li a0, 0 #stores # of 1s
call ONES
j end

ONES: 
	addi sp, sp, -4
	sw s0, 0(sp)
	
	loop:
		mv s0, a1
		andi s0, s0, 1
		add a0, a0, s0
		srli a1, a1, 1
		bnez a1, loop
	
	lw s0, 0(sp)
	addi sp, sp, 4
	ret

end: la t0, Answer
sw a0, (t0)

stop: j stop

.data
InputWord: .word 0x4a01fead

Answer: .word 0