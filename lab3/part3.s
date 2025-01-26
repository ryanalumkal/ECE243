/* Program to Count the number of 1's and Zeroes in a sequence of 32-bit words,
and determines the largest of each */

.global _start
_start:

/* Your code here  */
	
	la s0, TEST_NUM #load address of TEST_NUM (first val) to s0
	lw s1, (s0) #load first val into s1
	
	la s2, LargestOnes #load address of LargestOnes in s2
	lw s3, (s2) #load value of LargestOnes in s3
	
	la s4, LargestZeroes #load address of LargestZeros in s2
	lw s5, (s4) #load value of LargestZeros in s3
	
loop: beq s1, x0, finish #while s1 != 0
	ones_loop:
		mv a0, s1 #load value of s1 into a0 for pass-by val + return val
		call ONES
		bge s3, a0, zeros_loop #if the current result is not greater than all time result, move on
		mv s3, a0 #else, modify all time greatest result
	zeros_loop:
		xor s1, s1, -1
		mv a0, s1
		call ONES
		bge s5, a0, next_val #if the current result is not greater than all time result, move on
		mv s5, a0 #else, modify all time greatest result
	next_val:
		addi s0, s0, 4 #go to next value
		lw s1, (s0)

		j loop #jump back to loop start
	

/* ONES FUNCTION*/
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
/* END OF FUNCTION */

finish:

	sw s3, (s2) #store value into mem
	sw s5, (s4) #store value into mem

stop: j stop

.data
TEST_NUM:  .word 0x4a01fead, 0xF677D671,0xDC9758D5,0xEBBD45D2,0x8059519D
            .word 0x76D8F0D2, 0xB98C9BB5, 0xD7EC3A9E, 0xD9BADC01, 0x89B377CD
            .word 0  # end of list 

LargestOnes: .word 0
LargestZeroes: .word 0