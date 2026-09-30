// test_chaser.c
// Check LED movement and buttons
// OlexandrI.B

#include "chaser.h"
#include <assert.h>
#include <stdio.h>

static unsigned checks;

#define CHECK(x)                                                                                   \
    do {                                                                                           \
        assert(x);                                                                                 \
        checks++;                                                                                  \
    } while (0)

// Feed button samples and check press events
static void samples(chaser_t *s, unsigned raw, unsigned n, unsigned expected) {
    unsigned observed = 0;
    for (unsigned i = 0; i < n; ++i)
        observed |= chaser_sample(s, (uint8_t)raw);
    CHECK(observed == expected);
}

int main(void) {
    chaser_t s;
    chaser_init(&s);
    CHECK(s.position == 0 && s.speed == 2 && s.running == 1);

    // ~ Check forward and reverse wrap
    for (unsigned i = 0; i < 1000; ++i) {
        chaser_step(&s, 0);
        CHECK(s.position == ((i + 1) & 3));
    }
    for (unsigned i = 0; i < 1000; ++i) {
        chaser_step(&s, 1);
        CHECK(s.position == ((3 - i) & 3));
    }

    // ~ Pause, speed limits and button combinations
    chaser_controls(&s, BTN_STOP);
    for (unsigned i = 0; i < 1000; ++i) {
        chaser_step(&s, i & 1);
        CHECK(s.position == 0);
    }
    for (unsigned i = 0; i < 12; ++i)
        chaser_controls(&s, BTN_FASTER);
    CHECK(s.speed == 0 && !s.running);
    for (unsigned i = 0; i < 12; ++i)
        chaser_controls(&s, BTN_SLOWER);
    CHECK(s.speed == 3 && !s.running);
    chaser_controls(&s, BTN_STOP | BTN_RESUME);
    CHECK(!s.running);
    chaser_controls(&s, BTN_RESUME);
    CHECK(s.running);
    CHECK(!chaser_controls(&s, BTN_FASTER | BTN_SLOWER));
    CHECK(s.speed == 3);

    // ~ Bounce, held button and next press
    for (unsigned button = 1; button <= 8; button <<= 1) {
        chaser_init(&s);

        for (unsigned i = 0; i < 100; ++i) {
            samples(&s, button, DEBOUNCE_SAMPLES - 1, 0);
            samples(&s, 0, 1, 0);
        }

        samples(&s, button, DEBOUNCE_SAMPLES, button);
        samples(&s, button, 100, 0);
        samples(&s, 0, DEBOUNCE_SAMPLES - 1, 0);
        samples(&s, button, 1, 0); // release bounce, still the same press
        samples(&s, 0, DEBOUNCE_SAMPLES, 0);
        samples(&s, button, DEBOUNCE_SAMPLES, button);
    }

    chaser_init(&s);
    samples(&s, 15, DEBOUNCE_SAMPLES, 15);
    CHECK(s.stable_buttons == 15);

    samples(&s, 0, DEBOUNCE_SAMPLES, 0);
    CHECK(s.stable_buttons == 0);

    puts("PASS: forward/reverse wrap, pause invariance, bounds, button chords,");
    puts("      per-button debounce, held keys, release bounce and re-press");
    printf("ALL C TESTS PASSED: %u assertions; debounce threshold = %u samples\n", checks, DEBOUNCE_SAMPLES);
}
