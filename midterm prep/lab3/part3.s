.global _start
_start:
	
	li sp, 4000
	la a0, TEST_NUM
	lw a1, 0x0(a0)
	
	
	li a0, LargestZero
	lw a
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
TEST_NUM:  .word 0x4a01fead, 0xF677D671,0xDC9758D5,0xEBBD45D2,0x8059519D
            .word 0x76D8F0D2, 0xB98C9BB5, 0xD7EC3A9E, 0xD9BADC01, 0x89B377CD
            .word 0  # end of list 

LargestOnes: .word 0
LargestZeroes: .word 0