// main.c
// LED chaser with hardware timers
// OlexandrI.B

#include "chaser.h"
#include "mmio.h"

// Shorter periods for simulation, same program logic
#ifdef SIMULATION
static const uint32_t periods[4] = {25000, 50000, 100000, 200000};
#define SCAN_CLOCKS 2000u
#else
// 125, 250, 500, 1000 ms at 50 MHz
static const uint32_t periods[4] = {6250000, 12500000, 25000000, 50000000};
#define SCAN_CLOCKS 50000u
#endif

// Stop timer, load new period, then start if needed
static void timer_set(uint32_t base, uint32_t clocks, uint8_t run) {
    io_write(base + TIMER_CONTROL, TIMER_STOP);
    io_write(base + TIMER_STATUS, 0);
    io_write(base + TIMER_PERIODL, (clocks - 1u) & 0xffffu);
    io_write(base + TIMER_PERIODH, (clocks - 1u) >> 16);
    if (run)
        io_write(base + TIMER_CONTROL, TIMER_CONT | TIMER_START);
}

// LED output and status for the testbench
static void publish(const chaser_t *s, uint8_t reverse) {
    io_write(LEDS, 1u << s->position);
    io_write(DEBUG_PIO, 0x80000000u | s->running | ((uint32_t)s->speed << 1) |
                            ((uint32_t)s->position << 3) | ((uint32_t)reverse << 5) |
                            ((uint32_t)s->stable_buttons << 8));
}

int main(void) {
    chaser_t state;
    chaser_init(&state);
    timer_set(MOVE_TIMER, periods[state.speed], 1);
    timer_set(SCAN_TIMER, SCAN_CLOCKS, 1);
    publish(&state, 0);
    for (;;) {
        uint8_t reverse = (uint8_t)(io_read(SWITCHES) & 1u);
        // ~ Read buttons first, STOP has priority over timer timeout
        if (io_read(SCAN_TIMER + TIMER_STATUS) & TIMER_TO) {
            io_write(SCAN_TIMER + TIMER_STATUS, 0);
            uint8_t events = chaser_sample(&state, (uint8_t)io_read(BUTTONS));
            if (chaser_controls(&state, events))
                timer_set(MOVE_TIMER, periods[state.speed], state.running);
            publish(&state, reverse);
        }

        // ~ Move to next LED when hardware timer expires
        if (io_read(MOVE_TIMER + TIMER_STATUS) & TIMER_TO) {
            io_write(MOVE_TIMER + TIMER_STATUS, 0);
            chaser_step(&state, reverse);
            publish(&state, reverse);
        }
    }
}
