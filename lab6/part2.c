#define AUDIO_BASE 0xFF203040
int main(void) {

	volatile int * audio_ptr = (int *) AUDIO_BASE;
	int left, right, fifospace;

	while (1) {
		fifospace = *(audio_ptr + 1); 

		if ((fifospace & 0x000000FF) > 0){

			int left = *(audio_ptr + 2); 
			int right = *(audio_ptr + 3); 
			*(audio_ptr + 2) = left;  
			*(audio_ptr + 3) = right;
		}
	}
}