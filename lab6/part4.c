#define AUDIO_BASE 0xFF203040
#define DELAY_SAMPLES 3200 //8k / 0.4 for 0.4 second delay
#define DAMPING 0.4
	
int left_delay[DELAY_SAMPLES] = {0};
int right_delay[DELAY_SAMPLES] = {0};

struct audio_t
{
    volatile unsigned int control; // Control register
    volatile unsigned char rarc;   // number of stuff in input right channel
    volatile unsigned char ralc;   // number of stuff in input left channel
    volatile unsigned char wsrc;   // number of stuff in output right channel
    volatile unsigned char wslc;   // number of stuff in ouput left channel
    volatile unsigned int ldata;   // Left channel data
    volatile unsigned int rdata;   // Right channel data
};

struct audio_t *const audiop = (struct audio_t *)AUDIO_BASE;

int main(void) {

	int sample = 0;
	
	while (1) {
		if (audiop->rarc >= 0){
			int left = audiop->ldata; 
			int right = audiop->rdata;

			int left_output = left + (int)(DAMPING * left_delay[sample]); //wait 3200 samples/4sec?
			int right_output = right + (int)(DAMPING * right_delay[sample]);

			while (audiop->wsrc == 0){
			}

			audiop->ldata = left_output;  
			audiop->rdata = right_output;

			left_delay[sample] = left_output;
			right_delay[sample] = right_output;

			sample = (sample++)%DELAY_SAMPLES;
		}
	}
	return 0;
}