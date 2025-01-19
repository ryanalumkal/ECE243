.global _start
_start:

# s3 should contain the grade of the person with the student number, -1 if not found
# s0 has the student number being searched

    li s0, 718293

# Your code goes below this line and above iloop

	la a1, Snumbers #store address of Snumbers in a1
	lw a2, (a1) #store first student number in a2
	
	la t1, Grades #store address of Grades in t1
	lb t2, (t1) #store first grade in t2
	
loop:
	beq a2, s0, finished1 #if student numbers match, s0 == a2, finish
	beq a2, x0, finished2 #if student number DNE, a2 == 0, finish
	
	#continue to next set of addresses and values
	
	addi a1, a1, 4
	lw a2, (a1)
	
	addi t1, t1, 1
	lb t2, (t1)
	
	j loop #go back to loop

finished1:
	la s3, result
	sb t2, (s1)
	j iloop
	
finished2:
	la s3, result
	li t2, -1
	sb t2, (s1)

iloop: j iloop

/* result should hold the grade of the student number put into s0, or
-1 if the student number isn't found */ 
		
/* Snumbers is the "array," terminated by a zero of the student numbers  */
Snumbers: .word 10392584, 423195, 644370, 496059, 296800
        .word 265133, 68943, 718293, 315950, 785519
        .word 982966, 345018, 220809, 369328, 935042
        .word 467872, 887795, 681936, 0

result: .byte 0

/* Grades is the corresponding "array" with the grades, in the same order*/
Grades: .byte 99, 68, 90, 85, 91, 67, 80
        .byte 66, 95, 91, 91, 99, 76, 68  
        .byte 69, 93, 90, 72