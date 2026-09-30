// chaser.h
// Common LED chaser state
// OlexandrI.B

#ifndef CHASER_H
#define CHASER_H
#include <stdint.h>
enum { BTN_FASTER = 1, BTN_SLOWER = 2, BTN_STOP = 4, BTN_RESUME = 8 };
typedef struct {
    uint8_t position, speed, running, stable_buttons;
    uint8_t debounce[4];
} chaser_t;
void chaser_init(chaser_t *s);
// One event per button press
uint8_t chaser_sample(chaser_t *s, uint8_t raw);
// Nonzero when timer settings need an update
int chaser_controls(chaser_t *s, uint8_t edges);
void chaser_step(chaser_t *s, uint8_t reverse);
#ifdef SIMULATION
#define DEBOUNCE_SAMPLES 3u
#else
#define DEBOUNCE_SAMPLES 20u
#endif
#endif
