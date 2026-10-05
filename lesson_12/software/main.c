// main.c
// Start one frame after a button press, DMA stores it in RAM
// OlexandrI.B

#include <stdint.h>

#define REG(address) (*(volatile uint32_t *)(uintptr_t)(address))
#define BUTTON 0x10000u
#define DEBUG  0x10010u
#define DMA    0x10020u
#define DESC   0x10040u
#define RESPONSE 0x10060u
#define RX     0x10100u
#define FRAME_RAM 0x20000u
#define FRAME_BYTES (320u * 200u)
#define FRAME_WORDS (FRAME_BYTES / 4u)
#define RAM_WORDS (65536u / 4u)
#define GUARD 0xcafef00du

static void status(uint32_t frame, uint32_t state) {
    REG(DEBUG) = (frame << 16) | state;
}

static void fail(uint32_t code) {
    REG(DEBUG) = 0xdead0000u | code;
    for (;;) {}
}

// Require a stable level; short pulses must not count as a press
static void wait_button(uint32_t level) {
    unsigned stable = 0;
    while (stable < 32) {
        if ((REG(BUTTON) & 1u) == level) stable++;
        else stable = 0;
    }
}

int main(void) {
    uint32_t frame = 0;
    for (;;) {
        status(frame, 1);
        wait_button(0);
        status(frame, 2);
        wait_button(1);
        frame++;

        // Guard the unused tail and mark the first/last frame words
        for (unsigned i = FRAME_WORDS; i < RAM_WORDS; i++) REG(FRAME_RAM + 4*i) = GUARD;
        REG(FRAME_RAM) = GUARD;
        REG(FRAME_RAM + 4*(FRAME_WORDS-1)) = GUARD;
        REG(DMA + 4) = 0;                 // dispatcher enabled
        REG(DESC + 0) = 0;                // no MM read address in ST->MM mode
        REG(DESC + 4) = FRAME_RAM;
        REG(DESC + 8) = FRAME_BYTES;
        REG(DESC + 12) = 0x80000000u;     // GO, control written last
        REG(RX) = 1;                      // only software arms the receiver
        status(frame, 3);

        // Read completion response only when it is available
        while (REG(DMA) & 8u) { }
        uint32_t transferred = REG(RESPONSE);
        uint32_t errors = REG(RESPONSE + 4);
        if (transferred != FRAME_BYTES || errors != 0) fail(1);
        while (REG(DMA) & 1u) { }
        if (REG(RX + 4) != FRAME_WORDS) fail(2);
        status(frame, 4);

        // The simulation checks a known pattern; hardware accepts any pixel data
    #ifdef SIMULATION
        for (unsigned i = 0; i < FRAME_WORDS; i++) {
            uint32_t first = i*52u + 7u + frame*31u;
            uint32_t expected = (first & 255u) | (((first+13u)&255u)<<8)
                              | (((first+26u)&255u)<<16) | (((first+39u)&255u)<<24);
            if (REG(FRAME_RAM + 4*i) != expected) fail(3);
        }
    #endif

        for (unsigned i = FRAME_WORDS; i < RAM_WORDS; i++)
            if (REG(FRAME_RAM + 4*i) != GUARD) fail(4);
        status(frame, 5);
        // A held button cannot start the next frame: release is required
    }
}
