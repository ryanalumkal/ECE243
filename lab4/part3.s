.equ TIMER0_BASE, 0xFF202000
.equ TIMER0_STATUS, 0
.equ TIMER0_CONTROL, 4
.equ TIMER0_PERIODL, 8
.equ TIMER0_PERIODH, 12
#.equ TIMER0_SNAPL, 16
#.equ TIME0_SNAPH, 20

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
	
	j WAIT

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

WAIT:
	#stop the timer
	la t2, TIMER0_BASE
	li s0, 0x8 
	sw s0, TIMER0_CONTROL(t2)
	
	#set the period registers to 100M
	.equ TICKSPERSEC, 25000000
	.equ TICKSPERSECHIGH, (TICKSPERSEC >> 16) #%hi
	.equ TICKSPERSECLOW, (TICKSPERSEC & 0x0000FFFF) #%low
	li s0, TICKSPERSECLOW
	sw s0, TIMER0_PERIODL(t2)
	li s0, TICKSPERSECHIGH
	sw s0, TIMER0_PERIODH(t2)
	
	li s0, 0x6
	sw s0, TIMER0_CONTROL(t2)
	
TIME:
	lw s0, TIMER0_STATUS(t2)
	andi s0, s0, 1
	beq s0, x0, TIME
	
	#clear TO
	sw x0, TIMER0_STATUS(t2)
	
	#stop counter
	li s0, 8
	sw s0, TIMER0_CONTROL(t2)
	j LOOP


.data
n: .word 255