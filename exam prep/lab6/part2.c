int main(void){
	volatile int* AUDIO_ptr = 0xff203040;	
	
	while(1){
		if((*(AUDIO_ptr + 1) & 0x000000FF) >0){
			*(AUDIO_ptr + 2) = *(AUDIO_ptr + 2);
			*(AUDIO_ptr + 3) = *(AUDIO_ptr + 3);
		}
		
	}
}