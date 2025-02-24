#define AUDIO_BASE 0xFF203040
#define SWITCHES_BASE 0xFF200040

#define HIGH 0x11111111       
#define LOW (-0x11111111) 

#define SAMPLING_RATE 8000

struct audio_t
{
    volatile unsigned int control; 
    volatile unsigned char rarc;  
    volatile unsigned char ralc;  
    volatile unsigned char wsrc;   
    volatile unsigned char wslc;   
    volatile unsigned int ldata;  
    volatile unsigned int rdata; 
};

struct audio_t *const audiop = (struct audio_t *)AUDIO_BASE;
volatile unsigned int *const switches = (int *)SWITCHES_BASE;

int main(void)
{
    audiop->control = 0xC;
    audiop->control = 0x0; 

    while (1)
    {

        int sw_val = (*switches) & 0x3FF;
        
        double frequency = 100.0 + ((double)sw_val / 1023.0) * (2000.0 - 100.0); //linear probing
        double half_per = (int)((SAMPLING_RATE / (2.0 * frequency)) + 0.5);

        for (int i = 0; i < half_per; i++)
        {
            while (audiop->wsrc == 0)
            {
            }
			
            audiop->ldata = HIGH;
            audiop->rdata = HIGH;
        }

        for (int i = 0; i < half_per; i++)
        {
            while (audiop->wsrc == 0)
            {
            }

            audiop->ldata = LOW;
            audiop->rdata = LOW;
        }
    }

    return 0;
}