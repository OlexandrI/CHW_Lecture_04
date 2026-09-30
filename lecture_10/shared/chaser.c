// chaser.c
// LED movement and button control
// OlexandrI.B

#include "chaser.h"

// Starting values
void chaser_init(chaser_t *s) {
    s->position = 0;
    s->speed = 2;
    s->running = 1;
    s->stable_buttons = 0;
    for (unsigned i = 0; i < 4; ++i)
        s->debounce[i] = 0;
}

// Check each button separately, return only new presses
uint8_t chaser_sample(chaser_t *s, uint8_t raw) {
    uint8_t edges = 0;
    for (unsigned i = 0; i < 4; ++i) {
        uint8_t mask = (uint8_t)(1u << i);
        if ((raw & mask) == (s->stable_buttons & mask))
            s->debounce[i] = 0;
        else if (++s->debounce[i] >= DEBOUNCE_SAMPLES) {
            s->debounce[i] = 0;
            s->stable_buttons ^= mask;
            edges |= s->stable_buttons & mask;
        }
    }
    return edges;
}

// Speed limits and STOP / RESUME priority
int chaser_controls(chaser_t *s, uint8_t edges) {
    uint8_t old_speed = s->speed, old_running = s->running;
    if ((edges & (BTN_FASTER | BTN_SLOWER)) == BTN_FASTER && s->speed > 0)
        --s->speed;
    if ((edges & (BTN_FASTER | BTN_SLOWER)) == BTN_SLOWER && s->speed < 3)
        ++s->speed;
    if (edges & BTN_STOP)
        s->running = 0;
    else if (edges & BTN_RESUME)
        s->running = 1;
    return old_speed != s->speed || old_running != s->running;
}

// Wrap position in both directions, keep current LED while paused
void chaser_step(chaser_t *s, uint8_t reverse) {
    if (s->running)
        s->position = (uint8_t)((s->position + (reverse ? 3u : 1u)) & 3u);
}
