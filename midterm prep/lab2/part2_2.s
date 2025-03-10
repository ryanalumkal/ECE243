.global _start
_start:

# s3 should contain the grade of the person with the student number, -1 if not found
# s0 has the student number being searched

    li s0, 718293
	li s3, -1


# Your code goes below this line and above iloop

	la x10, Snumbers
	lw x11, (x10)
	
	la x12, Grades
	lb x13, (x12)
	
while: beqz x11, finished
	
	beq s0, x11, if_true
	
	addi x10, x10, 4
	lw x11, (x10)
	
	addi x12, x12, 1
	lb x13, (x12)
	
	j while
	
	if_true: addi s3, x13, 0
	
finished:
	la x10, result
	sb s3, (x10)

iloop: j iloop

/* result should hold the grade of the student number put into s0, or
-1 if the student number isn't found */ 

result: .byte 0

.align 3
		
/* Snumbers is the "array," terminated by a zero of the student numbers  */
Snumbers: .word 10392584, 423195, 644370, 496059, 296800
        .word 265133, 68943, 718293, 315950, 785519
        .word 982966, 345018, 220809, 369328, 935042
        .word 467872, 887795, 681936, 0

/* Grades is the corresponding "array" with the grades, in the same order*/


Grades: .byte 99, 68, 90, 85, 91, 67, 80
        .byte 66, 95, 91, 91, 99, 76, 68  
        .byte 69, 93, 90, 72