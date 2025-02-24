#define AUDIO_BASE 0xFF203040
#define SWITCHES_BASE 0xFF200040

#define AMPLITUDE 0x10000000        // High level of square wave
#define NEG_AMPLITUDE (-0x10000000) // Low level of square wave

#define SAMPLING_RATE 8000

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
volatile unsigned int *const switches = (int *)SWITCHES_BASE;

void audio_SquareWave_Generator()
{
    audiop->control = 0xC; // Clear both input and output FIFOs (set CW and CR bits)
    audiop->control = 0x0; // Resume conversion (clear the clear bits)

    while (1)
    {
        // read the switch value
        int sw_val = (*switches) & 0x3FF;
        // calculate the frequency by linear probing
        double frequency = 100.0 + ((double)sw_val / 1023.0) * (2000.0 - 100.0);
        // calculate the half period of the square wave
        double halfPeriod = (int)((SAMPLING_RATE / (2.0 * frequency)) + 0.5);

        // generate the top half of the square wave
        for (int i = 0; i < halfPeriod; i++)
        {
            // Wait until there is space in the output FIFO.
            while (audiop->wsrc == 0)
            {
            }

            // Write the samples to the output FIFOs.
            audiop->ldata = AMPLITUDE;
            audiop->rdata = AMPLITUDE;
        }
        // generate the bottom half of the square wave
        for (int i = 0; i < halfPeriod; i++)
        {
            // Wait until there is space in the output FIFO.
            while (audiop->wsrc == 0)
            {
            }

            // Write the samples to the output FIFOs.
            audiop->ldata = NEG_AMPLITUDE;
            audiop->rdata = NEG_AMPLITUDE;
        }
    }
}

int main(void)
{
    audio_SquareWave_Generator();
}