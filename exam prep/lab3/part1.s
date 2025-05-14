/* Program to Count the number of 1’s in a 32-bit word,
located at InputWord */
.global _start
_start:

/* Put your code here */
la t0, InputWord
lw t1, (t0)
li t2, 0 #stores # of 1s

count: beq t1, x0, end
	mv t3, t1
	andi t3, t3, 1
	add t2, t2, t3
	srli t1, t1, 1
	j count

end: la t0, Answer
sw t2, (t0)

stop: j stop

.data
InputWord: .word 0x4a01fead

Answer: .word 0