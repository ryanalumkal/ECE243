.global _start
_start:
	
LED:
	li a0, 0xFF200000 #LED PIT/OUTPUT
	li a1, 1 #stores numbers for LED
	sw x0, (a0)
BUTTON:
	li t0, 0xFF200050 #BUTTON PIT/OUTPUT

BUTTON_PRESSED_LOOP:
	lw t1, (t0) #read BUTTON PIT DR
	lw t6, (t0) #stores the original t1 val
	andi t2, t1, 1
	bne t2, x0, BUTTON_RELEASED_LOOP # checks if button 0 is pressed
	
	srli t1, t1, 1 #shift bit
	andi t2, t1, 1
	bne t2, x0, BUTTON_RELEASED_LOOP # checks if button 1 is pressed
	
	srli t1, t1, 1 #shift bit
	andi t2, t1, 1
	bne t2, x0, BUTTON_RELEASED_LOOP # checks if button 2 is pressed
	
	srli t1, t1, 1 #shift bit
	andi t2, t1, 1
	bne t2, x0, BUTTON_RELEASED_LOOP # checks if button 3 is pressed
	
	j BUTTON_PRESSED_LOOP

BUTTON_RELEASED_LOOP:
	lw t3, (t0) #read BUTTON PIT DR
	#CHECK IF KEY3 WAS PREVIOUSLY PRESSED, IF IT WAS AND BUTTONS ARE PRESSED
	# DO SPECIAL FUNC
	beq t6, t3, BUTTON_RELEASED_LOOP #IF BUTTON HAS NOT BEEN UPDATED

CHECK_COND:
	andi t4, t6, 1 #check 0 BUTTON
	bne t4, x0, DISPLAY # checks if button 0 is released
	
	srli t6, t6, 1 #shift by 1 bit
	andi t4, t6, 1
	bne t4, x0, INCREMENT #checks if button 1 is released
	
	srli t6, t6, 1 #shift by 1 bit
	andi t4, t6, 1
	bne t4, x0, DECREMENT #checks if button 1 is released
	
	
	j BUTTON_PRESSED_LOOP

DISPLAY: #KEY0 is pressed
	sw a1, 0(a0) #display 

	j BUTTON_PRESSED_LOOP

INCREMENT: #KEY1 is pressed

	li s10, 15
	beq a1, s10, DISPLAY
	addi a1, a1, 1
	j DISPLAY

DECREMENT: #KEY2 is pressed
	li s10, 1
	beq a1, s10, DISPLAY #if button is already 1
	addi a1, a1, -1
	j DISPLAY

BLANK_DISPLAY: #KEY3 is pressed 

#TODO
	
	li a1, 0
	sw a1, 0(a0)
	
	j BUTTON_PRESSED_LOOP
	
