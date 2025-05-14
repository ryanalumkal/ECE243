.global _start
_start:
	
	.equ LEDs, 0xff200000
	.equ PUSH_BUTTONS, 0xff200050
	
	li a0, 0
	la t0, LEDs
	la t1, PUSH_BUTTONS
	li a1, 0
	
	WAIT_KEY_PRESSED:
		lw s10, 0(t1)
		bne s10, x0, WAIT_KEY_RELEASED
		j WAIT_KEY_PRESSED
	
	WAIT_KEY_RELEASED:
		lw s9, 0(t1)
		beqz s9, FIND_FUNC
		j WAIT_KEY_RELEASED
	
	FIND_FUNC:
	
		li s11, 1
		
		beq a1, s11, KEY_0_SPECIAL #always go to KEY_O if any button is pressed and a1 == 1
		
		andi s9, s10, 1
		bnez s9, KEY_0
		
		andi s9, s10, 2
		bnez s9, KEY_1
		
		andi s9, s10, 4
		bnez s9, KEY_2
		
		andi s9, s10, 8
		bnez s9, KEY_3
		
		j WAIT_KEY_PRESSED
	
	KEY_0_SPECIAL:
		li a0, 1
		sw a0, (t0)
		xori a1, a1, 1
		j WAIT_KEY_PRESSED
	
	KEY_0:
		li a0, 1
		sw a0, (t0)
		j WAIT_KEY_PRESSED
	
	KEY_1:
		li s10, 15
		bge a0, s10, KEY_1_END
		addi a0, a0, 1
		sw a0, (t0)
		KEY_1_END: j WAIT_KEY_PRESSED

	KEY_2:
		li s10, 1
		ble a0, s10, KEY_2_END
		addi a0, a0, -1
		sw a0, (t0)
		KEY_2_END: j WAIT_KEY_PRESSED
	
	KEY_3:
		li a0, 0
		sw a0, (t0)
		xori a1, a1, 1 #flips a1 val
		j WAIT_KEY_PRESSED
	
jloop: j jloop