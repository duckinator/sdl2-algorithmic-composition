#include <stdint.h>
#include <stddef.h>
#include <stdlib.h> // for malloc()
#include <string.h> // for memset()

#include <SDL2/SDL.h>
#include "oscillators.h"
#include "audio.h"
#include "synth.h"

// These are the actual synthesizers! The number is hard-coded, atm.
static Synth *synths[] = {
    NULL,
    NULL,
    NULL, /* To terminate foreach(). */
};

// Magical variable used to generate audio.
static long i = 0;

Synth *synth_new(SynthOscillatorFn *oscillator, size_t frequency,
                 int a, int b, int c)
{
    Synth *synth = malloc(sizeof(Synth));
    memset(synth, 0, sizeof(Synth));

    synth_update(synth, oscillator, frequency, a, b, c);
    synth->enabled = false;

    if (synth_register) {
        synth_register(synth);
    }

    return synth;
}

void synth_update(Synth *synth, SynthOscillatorFn *oscillator,
                  size_t frequency, int a, int b, int c)
{
    synth->oscillator   = oscillator;
    synth->frequency    = frequency;
    synth->a            = a;
    synth->b            = b;
    synth->c            = c;
}

void run_synth(Synth *synth, int *buffer, uint32_t buffer_idx) {
    long int idx = (i >> synth->a | i >> synth->b) & (i >> synth->c);

    buffer[buffer_idx] = louder(synth->oscillator(synth->frequency, idx)) - 50;
    i++;
}

void generate_chunk(int *buffer, uint32_t length)
{
    size_t sidx = 0;
    for (uint32_t idx = 0; idx < length; idx += sidx) {
        for (sidx = 0; synths[sidx] != NULL; sidx++) {
            run_synth(synths[sidx], buffer, idx + sidx);
        }
    }
}

void synth_register_callback(SynthCreationCallback *fn)
{
    synth_register = fn;
}

bool synth_setup(int argc, char *argv[])
{
    // We don't use argc or argv.
    (void)argc;
    (void)argv;

    synths[0] = synth_new(sawtooth, 30, 12, 3,  4);
    synths[1] = synth_new(square,   60, 10, 3, -2);

    return audio_setup(generate_chunk);
}
