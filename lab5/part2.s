.global _start
_start:


.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030

.equ PUSH_BUTTON, 0xFF200050

#Your code goes below here:

#Your code should:

#Turn off interrupts in case an interrupt is called before correct set up
 	csrw mstatus, zero
	
#Initialize the stack pointer
	li sp, 0x200000

#activate interrupts from IRQ18 (Pushbuttons)
	li    a2, 0x40000
	csrrs x0, mie, a2
	
#Set the mtvec register to be the interrupt_handler location
	la a2, interrupt_handler
	csrrw x0, mtvec, a2
	
/*Allow interrupts on the pushbutton's interrupt mask register, and any 
#additional set up for the pushbuttons */
	li a4, 0xff200050 # buttons
	li a2, 0xF        # first make sure the EDGE register is all clear
	sw a2, 12(a4)     # reset EDGE bits
	li a2, 0xF       # set MASK bit 0 to 1, enable int requests for button 0
	sw a2, 8(a4)
	li t5, 0
	li t1, 1
	li t2, 2
	li t3, 3
	li t0, 0
	
		
 
#Now that everything is set, turn on Interrupts in the mstatus register
	li  a2, 0x8
	csrrs x0, mstatus, a2
	
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
addi sp, sp,-24
sw ra, 0(sp)
sw a0, 4(sp)
sw a1, 8(sp)
sw a3, 12(sp)
sw t5, 16(sp)
sw t6, 20(sp)




li a4, 0xff200050   # Reload pushbutton base address
lw a3, 12(a4) 
li t6, 0xF
sw t6, 12(a4) #clear edge capture register

andi t5, a3, 1
li a0,0
li a1, 0
bne t5, x0, toggle

andi t5, a3, 2
li a0,1
li a1, 1

bne t5, x0, toggle

andi t5, a3, 4
li a0,2
li a1, 2
bne t5, x0, toggle

andi t5, a3, 8
li a0,3
li a1, 3
bne t5, x0, toggle
#Your KEY_ISR code here
here:
lw ra, 0(sp)
lw a0, 4(sp)
lw a1, 8(sp)
lw a3, 12(sp)
lw t5, 16(sp)
lw t6, 20(sp)

addi sp, sp, 24
ret

toggle:
	xor t0,t0,t5
	and t6, t0, t5
	beq t6, x0, call_blank
	j call_hex_disp
	
call_blank:
	li a0, 0b1000
	call HEX_DISP
	j here
	
call_hex_disp:
	call HEX_DISP
	j here


.equ HEX_BASE1, 0xff200020
.equ HEX_BASE2, 0xff200030

li sp, 0x20000

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
			
