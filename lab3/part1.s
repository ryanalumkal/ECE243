/* Program to Count the number of 1's in a 32-bit word,
located at InputWord */

.global _start
_start:
	
	/* Put your code here */
	
	la t0, InputWord #store word address
	lw t1, (t0) #store input into register t1 (as bits)
	
	li s0, 0 #s1 will store number of 1s
	li a0, 32 #for 32 total bits
	
count_loop: 
	andi t2, t1, 1 #compare LSB to 1 using "AND" -> store that value to t2
	beq t2, x0, shift #if t2 == 0, shift t1
	addi s0, s0, 1 #else, increment, then shift t1

shift:
	srl t1, t1, 1 #shift to the right by 1 (drop LSB) and make MSB 0
	addi a0, a0, -1 #decrement # of bits left by 1
	bne a0, x0, count_loop #if a0 != 0, go back to count_loop, else stop

	la t0, Answer
	sw s0, (t0)

    stop: j stop

.data
InputWord: .word 0x4a01fead

Answer: .word 0