int main(void){
	volatile int *LEDs_ptr = 0xff200000;
	volatile int* SWITCH_ptr = 0xff200050;
	
	*(SWITCH_ptr + 3) = 0b1111;
	
	while(1){
		int EDGE_CAP = *(SWITCH_ptr+3);
		*(SWITCH_ptr + 3) = 0b1111;
		if((EDGE_CAP & 0xF) != 0){
			if ((EDGE_CAP & 1) != 0){
				*LEDs_ptr = 0b1111111111;
			} else if ((EDGE_CAP & 0b10) != 0){
				*LEDs_ptr = 0;
			}
		}
		
	}
}