.global _start
_start:
	li t0, 0xFF200000 #LOAD LED PIT/OUTPUT
	sw x0, (t0)
	li t1, 0xFF200050 #LOAD BUTTON PIT/OUTPUT
	li a0, 0 #counter
	lw a1, (n)
	j RESTART

RESTART:
	li a0, 0
	sw a0, (t0)

LOOP:
	
	lw a2, 12 (t1) #read BUTTON PIT EDGE
	andi a2, a2, 0xF #check bit 0
	bne a2, x0, BUTTON_PRESSED #pressed, jump to pause
	
	addi a0, a0, 1
	sw a0, (t0)
	beq a0, a1, RESTART
	j DO_DELAY

BUTTON_PRESSED:
	li a2, 0xF
	sw a2, 12(t1) #reset BUTTON PIT EDGE
	
STOP:
	
	lw a2, 12 (t1) #read BUTTON PIT EDGE
	andi a2, a2, 0xF #check bit 0
	beq a2, x0, STOP #pressed, jump to pause
	li a2, 0xF
	sw a2, 12(t1) #reset BUTTON PIT EDGE
	j LOOP

DO_DELAY: 
	lw s0, (COUNTER_DELAY)
SUB_LOOP: 
	addi s0, s0, -1
	bnez s0, SUB_LOOP
	
j LOOP

.data
COUNTER_DELAY: .word 500000
n: .word 255