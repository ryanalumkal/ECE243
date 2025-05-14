.global _start
_start:

# s3 should contain the grade of the person with the student number, -1 if not found
# s0 has the student number being searched

    li s0, 718293

# Your code goes below this line and above iloop

	la t0, Snumbers
	lw t1, (t0) #first student number
	
	la t2, Grades
	lb t3, (t2) #first grade
	
	loop: beq t1, x0, not_found #if student# is 0
	
	beq t1, s0, endloop #if student was found
	
	addi t0, t0, 4
	addi t2, t2, 1
	
	lw t1, (t0)
	lb t3, (t2)
	
	j loop
	
	not_found: li t3, -1
	
	endloop: 
	la t0, result
	sb t3, (t0)

iloop: j iloop

.data

/* result should hold the grade of the student number put into s0, or
-1 if the student number isn't found */ 

result: .byte 0

.align 4

/* Snumbers is the "array," terminated by a zero of the student numbers  */
Snumbers: .word 10392584, 423195, 644370, 496059, 296800
        .word 265133, 68943, 718293, 315950, 785519
        .word 982966, 345018, 220809, 369328, 935042
        .word 467872, 887795, 681936, 0

/* Grades is the corresponding "array" with the grades, in the same order*/
Grades: .byte 99, 68, 90, 85, 91, 67, 80
        .byte 66, 95, 91, 91, 99, 76, 68  
        .byte 69, 93, 90, 72