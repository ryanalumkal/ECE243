.global _start
_start:


.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030

.equ PUSH_BUTTON, 0xFF200050

#Your code goes below here:

#Your code should:

#Turn off interrupts in case an interrupt is called before correct set up

#Initialize the stack pointer

#activate interrupts from IRQ18 (Pushbuttons)

#Set the mtvec register to be the interrupt_handler location

/*Allow interrupts on the pushbutton's interrupt mask register, and any 
#additional set up for the pushbuttons */

#Now that everything is set, turn on Interrupts in the mstatus register

csrw mstatus, zero #disable procesor level interrupts

li sp, 0x20000 #stack

#RESET DISPLAYS
li a0, 0xFF
li a1, 0
call HEX_DISP
li a0, 0xFF
li a1, 1
call HEX_DISP
li a0, 0xFF
li a1, 2
call HEX_DISP
li a0, 0xFF
li a1, 3
call HEX_DISP
li a0, 0xFF
li a1, 4
call HEX_DISP
li a0, 0xFF
li a1, 5

la t1, PUSH_BUTTON			# address of KEY registers base into t1
li t0, 0b1111		   # enable all buttons

sw t0, 8(t1) 			# Set interrupt enable - I.e. have it request an interrupt

sw t0, 12(t1) 			# This will clear Edge Capture bit of Keys

# Now, enable interrupts from the processor side (it won't respond to a request until enabled in 2 ways:

li t0, 0x40000 			# 0x40000 corresponds to bit 18 of 32 bit word being 1 
									# (The Keys request interrupts on line 18)

csrs mie, t0 			# this sets bit 18 of the MIE to 1, enabling interrupts specifically 
									# from the KEYs, and no other device

la t0, interrupt_handler    # put the address of interrupt handler routine into t0

csrw mtvec, t0 			# set MTVEC to contain that address - so proc knows where to go when interrupted 

li t0, 0b1000			# turn on bit three of register t0

csrs mstatus, t0      # use it to turn on bit 3 of MSTATUS - the MIE bit to enable processor interrupts


IDLE: j IDLE #Infinite loop while waiting on interrupt

interrupt_handler:
	addi sp, sp, -12
	
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw ra, 8(sp)
	
	li s0, 0x40000 #Checking if Interrupt comes from IRQ 18
	csrr s1, mcause
	
	and s1, s1, s0
	bnez s1, end_interrupt
	
	jal KEY_ISR # If so call KEY_ISR
	
	end_interrupt:

	
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw ra, 8(sp)
	
	addi sp, sp, 12

mret

KEY_ISR: 
		
	li s7, 0
	li s10, 0
	addi sp, sp, -4
	
	sw ra, 0(sp)
	
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw a0, 12(sp)
	sw a1, 16(sp)
		
	#Your KEY_ISR code here
	
	la t0, PUSH_BUTTON
	
	lw t1, 12(t0) #load edge-capture register
	

	#CHECK WHAT BUTTON IS PRESSED
	andi t2, t1, 1 #checks 0 bit
	li s8, 0
	li s9, 0
	bne t2, x0, CALL_DISP
	
	andi t2, t1, 2 #checks 1 bit
	li s8, 1
	li s9, 1
	bne t2, x0, CALL_DISP
	
	andi t2, t1, 4 #checks 2 bit
	li s8, 2
	li s9, 2
	bne t2, x0, CALL_DISP
	
	andi t2, t1, 8 #checks 3 bit
	li s8, 3
	li s9, 3
	bne t2, x0, CALL_DISP

	CALL_DISP:
		
		mv a0, s8
		mv a1, s9
		
		sw t1, 12(t0) #reset edge
		
		li s8, 0
		li s9, 0
		call HEX_DISP
	
	
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw a0, 12(sp)
	lw a1, 16(sp)
	
	addi sp, sp, 20
	
	lw ra, 0(sp)
	addi sp, sp, 4
	
ret

/*    Subroutine to display a four-bit quantity as a hex digits (from 0 to F) 
      on one of the six HEX 7-segment displays on the DE1_SoC.
*
 *    Parameters: the low-order 4 bits of register a0 contain the digit to be displayed
		  if bit 4 of a1 is a one, then the display should be blanked
 *    		  the low order 3 bits of a0 say which HEX display number 0-5 to put the digit on
 *    Returns: a0 = bit patterm that is written to HEX display
 */

.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030

#Your code Here:

iloop: j iloop

#Subroutine is here:

HEX_DISP:   
		addi sp, sp, -16
		sw s0,0(sp)
		sw s1,0x4(sp)
		sw s2,0x8(sp)
		sw s3,0xC(sp)
	
		la   s0, BIT_CODES         # starting address of the bit codes
	    andi     s1, a0, 0x10	       # get bit 4 of the input into r6
	    beq      s1, zero, not_blank 
	    mv      s2, zero
	    j       DO_DISP
not_blank:  andi     a0, a0, 0x0f	   # r4 is only 4-bit
            add      a0, a0, s0        # add the offset to the bit codes
            lb      s2, 0(a0)         # index into the bit codes

#Display it on the target HEX display
DO_DISP:    
			la       s0, HEX_BASE1         # load address
			li       s1,  4
			blt      a1,s1, FIRST_SET      # hex4 and hex 5 are on 0xff200030
			sub      a1, a1, s1            # if hex4 or hex5, we need to adjust the shift
			addi     s0, s0, 0x0010        # we also need to adjust the address
FIRST_SET:
			slli     a1, a1, 3             # hex*8 shift is needed
			addi     s3, zero, 0xff        # create bit mask so other values are not corrupted
			sll      s3, s3, a1 
			li     	 a0, -1
			xor      s3, s3, a0  
    		sll      a0, s2, a1            # shift the hex code we want to write
			lw    	 a1, 0(s0)             # read current value       
			and      a1, a1, s3            # and it with the mask to clear the target hex
			or       a1, a1, a0	           # or with the hex code
			sw    	 a1, 0(s0)		       # store back
END:			
			mv 		 a0, s2				   # put bit pattern on return register
			
			
			lw s0,0(sp)
			lw s1,0x4(sp)
			lw s2,0x8(sp)
			lw s3,0xC(sp)
			addi sp, sp, 16
			ret


.data
BIT_CODES:  .byte     0b00111111, 0b00000110, 0b01011011, 0b01001111
			.byte     0b01100110, 0b01101101, 0b01111101, 0b00000111
			.byte     0b01111111, 0b01100111, 0b01110111, 0b01111100
			.byte     0b00111001, 0b01011110, 0b01111001, 0b01110001

            .end
			
