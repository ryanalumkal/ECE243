volatile int *audio_ptr = 0xff203040;
	
int main(void){
	while(1){
		
		if((*(audio_ptr+1) & 0x000000FF) >0){
			int left_data = *(audio_ptr +2);
			int right_data = *(audio_ptr + 3);

			*(audio_ptr + 2) = left_data;
			*(audio_ptr + 3) = right_data;
		}
	}
	
	return 0;
}