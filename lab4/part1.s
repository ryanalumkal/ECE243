.global _start
_start:
    li t0, 0xFF200000  
    li t1, 0xFF200050  
    li s1, 0          
	li t5, 1

pressed:
    lw a0, 0(t1)      
    beq a0, x0, pressed  # waiting till pressed
mv t4, a0          # Store pressed button value

releasecheck:
    lw a0, 0(t1)      
    bne a0, x0,releasecheck  # waiting till released
	beq t6, t5, SETTOONE   
    andi t3, t4, 1     
    bne t3, x0, SETTOONE
	andi t3, t4, 2   
    bne t3, x0, INCREMENT
	andi t3, t4, 4    
    bne t3, x0, DECREMENT

    andi t3, t4, 8     
    bne t3, x0, BLANK

    j pressed  

DISPLAY:
    sw s1, 0(t0)  
    j pressed  

SETTOONE:
    li s1, 1
	li t6, 0
    j DISPLAY

INCREMENT:
    li t2, 15         # Max value allowed
    bge s1, t2, DISPLAY  
    addi s1, s1, 1   
    j DISPLAY
DECREMENT:
    li t2, 1         # Min value allowed
    ble s1, t2, DISPLAY  
    addi s1, s1, -1  
    j DISPLAY

BLANK:
    li s1, 0 
	li t6, 1
    j DISPLAY
