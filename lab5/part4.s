.global _start
_start:

	.equ LEDs,  0xFF200000
	.equ TIMER, 0xFF202000
	.equ BUTTONs, 0xFF200050

	#Set up the stack pointer
	li sp, 0x20000
	
	jal    CONFIG_TIMER        # configure the Timer
    jal    CONFIG_KEYS         # configure the KEYs port
	
	/*Enable Interrupts in the NIOS V processor, and set up the address handling
	location to be the interrupt_handler subroutine*/
	
	la s0, LEDs
	la s1, COUNT
	
	LOOP:
		lw     s2, 0(s1)          # Get current count
		sw     s2, 0(s0)          # Store count in LEDs
	j      LOOP


interrupt_handler:

	addi sp, sp, -12
	sw t0, (sp)
	sw t1, 4(sp)
	sw ra, 8(sp)
	
	#mcause tells what caused the interrupt (exactly what IRQ line)
	li t0, 0x7FFFFFFF
	csrr t1, mcause #encodes the IRQ Line # that caused the interrupt
	and t1, t1, t0 #zero bit 31 (not needed)
	
	li t0, 18 #for KEY
	bne t1, t0, JUMP_KEY
	call KEY_ISR
	j end_interrupt

	JUMP_KEY: #jumps here if interrupt was not KEY
		li t0, 16 #for TIMER
		bne t1, t0, end_interrupt
		call TIMER_ISR

	end_interrupt:

		lw t0, (sp)
		lw t1, 4(sp)
		lw ra, 8(sp)
		addi sp, sp, 12

mret

KEY_ISR:

	.equ TIMER0_STATUS, 0
	.equ TIMER0_CONTROL, 4
	.equ TIMER0_PERIODL, 8
	.equ TIMER0_PERIODH, 12
	
	#set the period registers to 25M, for 0.25 seconds
	.equ TICKSPERSEC, 25000000 

	addi sp, sp, -24
	sw t0, (sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	sw s0, 20(sp)
	
	#code
	
	la t0, BUTTONs
	lw t1, 12(t0)
	
	li t2, 1
	li t3, 2
	li t4, 4
	
	beq t1, t2, key_0
	beq t1, t3, key_1 #button 1
	beq t1, t4, key_2 
	
	
	la t0, RUN
	lw t1, (t0)
	
	li s0, TICKSPERSEC
	
	key_0: 
	la t0, RUN
	lw t1, (t0)
	xori t1, t1, 1
	sw t1, 0(t0)
	j done2
	
	key_1:
	li t0, 1000000
	beq t0, s0, done2
	srli s0, s0, 1
	
	j reset_timer
	
	key_2:
	li t0, 100000000
	beq t0, t1, done2
	slli s0, s0, 1
	
	j reset_timer
	
	reset_timer:
		#STOP TIMER
		la t2, TIMER #address of timer
		li t1, 0b1011
		sw t1, 4(t2)
	j done
	

done:
	la t2, TIMER #address of timer
	#AFTER ALL IS DONE
	.equ TICKSPERSECHIGH, (TICKSPERSEC >> 16) #%hi
	.equ TICKSPERSECLOW, (TICKSPERSEC & 0x0000FFFF) #%low
	li s0, TICKSPERSECLOW
	sw s0, TIMER0_PERIODL(t2)
	li s0, TICKSPERSECHIGH
	sw s0, TIMER0_PERIODH(t2)
	
	
	la t2, TIMER #address of timer
	li t1, 0x5
	sw t1, 4(t2)
	
done2:	

	la t0, BUTTONs
	li t1, 0xF
	sw t1, 12(t0)
	
	
	lw t0, (sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	lw s0, 20(sp)
	addi sp, sp, 24
	ret

	
TIMER_ISR:

	addi sp, sp, -12
	sw t0, (sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	
	#code
	la t0, COUNT
	lw t1, (t0)
	
	la t0, RUN
	lw t2, (t0)
	
	li t0, 255
	bne t1, t0, skip
	
	li t1,0
	j skip2


	skip:
	add t1, t1, t2 #COUNT += RUN (0 or 1)

	skip2:
	la t0, COUNT
	sw t1, (t0)
	
	la t0, TIMER
	li t1, 2
	sw t1, (t0) #reset TO
	
	lw t0, (sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12
	ret


CONFIG_TIMER: 
	
	#Code not shown
	
	addi sp, sp, -16
	sw t0, (sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw s0, 12(sp)
	
	.equ TIMER0_STATUS, 0
	.equ TIMER0_CONTROL, 4
	.equ TIMER0_PERIODL, 8
	.equ TIMER0_PERIODH, 12
	
	la t2, TIMER
	li s0, 0x8 
	sw s0, TIMER0_CONTROL(t2)
	
	#set the period registers to 25M, for 0.25 seconds
	.equ TICKSPERSEC, 25000000 
	.equ TICKSPERSECHIGH, (TICKSPERSEC >> 16) #%hi
	.equ TICKSPERSECLOW, (TICKSPERSEC & 0x0000FFFF) #%low
	li s0, TICKSPERSECLOW
	sw s0, TIMER0_PERIODL(t2)
	li s0, TICKSPERSECHIGH
	sw s0, TIMER0_PERIODH(t2)
	
	li s0, 0x6
	sw s0, TIMER0_CONTROL(t2)
	
	#SET ITO to 1
	li s0, 3
	sw s0, TIMER0_CONTROL(t2)
	
	li t0, 0x10000
	
	csrs mie, t0  #enables IRQ 16
	
	lw t0, (sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw s0, 12(sp)
	addi sp, sp, 16
	
ret

CONFIG_KEYS: #CHECK

	#Code not shown
	
	addi sp, sp, -12
	sw t0, (sp)
	sw t1, 4(sp)
	sw ra, 8(sp)
	
	
	la t1, BUTTONs
	li t0, 0b0111 #enable all buttons
	
	sw t0, 8(t1) 
	
	sw t0, 12(t1)
	
	li t0, 0x40000
	 
	csrs mie, t0 #tells processor to listen to bit 18 for interrupts (i.e. the button)
	
	la t0, interrupt_handler    # put the address of interrupt handler routine into t0

	csrw mtvec, t0 			# set MTVEC to contain that address - so proc knows where to go when interrupted 

	li t0, 0b1000			# turn on bit three of register t0

	csrs mstatus, t0      # use it to turn on bit 3 of MSTATUS - the MIE bit to enable processor interrupts

	lw t0, (sp)
	lw t1, 4(sp)
	lw ra, 8(sp)
	addi sp, sp, 12

ret

.data
/* Global variables */
.global  COUNT
COUNT:  .word    0x0            # used by timer

.global  RUN                    # used by pushbutton KEYs
RUN:    .word    0x1            # initial value to increment COUNT

.end
