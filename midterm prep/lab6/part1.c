volatile int *KEYS = 0xff200050;
int edge_cap;
volatile int *LEDS = 0xff200000;



int main(void){
	*LEDS = 0;
	*(KEYS+3) = 0b1111;
	while(1){
		edge_cap = *(KEYS+3);
		
		if (edge_cap & 1){
			*LEDS = 0;
			*(KEYS+3) = 0b1111;
		} else if (edge_cap & 2){
			*LEDS = 1023;
			*(KEYS+3) = 0b1111;
		}	
	}
	
	return 0;
}