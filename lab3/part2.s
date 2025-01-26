/* Program to Count the number of 1's in a 32-bit word,
located at InputWord */

.global _start
_start:
	
	/* Put your code here */
	la t0, InputWord #store word address
	lw a0, (t0) #store input into register a0 (as bits)
	
	call ONES
	
	j finish

ONES: 
	mv t5, a0 #move value of a0 into a new register
	li a0, 0 #a0 now stores result
	li t1, 32 #for 32 total bits
	
	count_loop: 
		andi t2, t5, 1 #compare LSB to 1 using "AND" -> store that value to t2
		beq t2, x0, shift #if t2 == 0, shift t1
		addi a0, a0, 1 #else, increment, then shift t1

	shift:
		srl t5, t5, 1 #shift to the right by 1 (drop LSB) and make MSB 0
		addi t1, t1, -1 #decrement # of bits left by 1
		bne t1, x0, count_loop #if a0 != 0, go back to count_loop, else stop

		ret
finish:

	la t0, Answer #store address of Answer
	sw a0, (t0) #write final result to Answer

stop: j stop



.data
InputWord: .word 0x4a01fead

Answer: .word 0