#define KEYs 0xFF200050
#define LEDs 0xFF200000

struct BUTTON{
	volatile unsigned int DR;
	volatile unsigned int DIR;
	volatile unsigned int IR;
	volatile unsigned int ED;
};

struct BUTTON *const keys_ptr = (struct BUTTON*)KEYs;
volatile int *leds_ptr = (int*) LEDs;

int main(void){
	*leds_ptr = 0;

	while(1){
		if (keys_ptr->ED & 0x1){
			*leds_ptr = 0x3FF;
			keys_ptr->ED = 1;
		}
		if (keys_ptr->ED & 0x2){
			*leds_ptr = 0x0;
			keys_ptr->ED = 3;
		}
	}
	return 0;
}