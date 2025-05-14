/* Program to Count the number of 1’s and Zeroes in a sequence of 32-bit words,
and determines the largest of each */
.global _start
_start:

/* Your code here */
#main
la sp, 0x20000
la t0, TEST_NUM
lw a1, (t0) #curr num
li t1, 0 #highest ONES count
li t2, 0 #highest ZEROS
li a0, 0 #count call

main_loop: beqz a1, finished
	call ONES
	blt a0, t1, ZEROS_CALL
	mv t1, a0
	
	ZEROS_CALL: 
	lw a1, (t0)
	li a0, 0
	xori a1, a1, -1
	call ONES
	blt a0, t2, NEXT_WORD
	mv t2, a0
	
	NEXT_WORD: 
	addi t0, t0, 4
	lw a1, (t0)
	li a0, 0
	j main_loop

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

finished:
la t0, LargestOnes
sw t1, (t0)
la t0, LargestZeroes
sw t2, (t0)

la t0, 0xff200000 #LED

display: 
	mv t3, t1
	li a0,  0x100000
	sw t3, (t0)
	call delay
	mv t3, t2
	li a0,  0x100000
	sw t3, (t0)
	call delay
	j display

delay: beqz a0, end_delay
	addi a0, a0, -1
	j delay
	end_delay: ret
	


.data
TEST_NUM: .word 0x4a01fead, 0xF677D671,0xDC9758D5,0xEBBD45D2,0x8059519D
		.word 0x76D8F0D2, 0xB98C9BB5, 0xD7EC3A9E, 0xD9BADC01, 0x89B377CD
		.word 0 # end of list
		
LargestOnes: .word 0
LargestZeroes: .word 0