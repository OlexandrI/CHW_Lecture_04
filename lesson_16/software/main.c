// main.c
// Control the metronome from Nios V/m
// OlexandrI.B

#include <stdint.h>
#define REG(address) (*(volatile uint32_t *)(address))
#define BPM    REG(0x10000)
#define ENABLE REG(0x10004)
#define TICKS  REG(0x10008)
#define STATUS REG(0x10010)
#ifdef SIMULATION
#define TIMEOUT 200000u
#define PAUSE 500u
#else
#define TIMEOUT 1000000000u
#define PAUSE 2000000u
#endif

static uint32_t checks;
static void check(int ok, uint32_t code) {
    if (!ok) {
        STATUS=0xdead0000u|code;
        for (;;) __asm__ volatile("nop");
    }
    checks++;
}
static void wait_ticks(uint32_t target) {
    uint32_t remaining=TIMEOUT;
    while (TICKS<target && --remaining) {}
    check(remaining!=0,0x100u+target);
}
static void delay(void) {
    for (volatile uint32_t n=0; n<PAUSE; n++) {}
}
int main(void) {
    STATUS=1;
    check(BPM==120 && ENABLE==0 && TICKS==0,1);

    // 120 BPM -> 60 BPM
    BPM=120; ENABLE=1;
    wait_ticks(4); check(BPM==120 && ENABLE==1,2);
    STATUS=2;
    BPM=60;
    uint32_t target=TICKS+3;
    wait_ticks(target); check(BPM==60,3);

    // Stop and restart
    STATUS=3; ENABLE=0;
    uint32_t stopped=TICKS;
    delay(); check(TICKS==stopped && ENABLE==0,4);
    BPM=120; ENABLE=1;
    check(TICKS==0,5);
    wait_ticks(2); ENABLE=0;

    // BPM limits: 30..240
    STATUS=4; BPM=0; check(BPM==30,6);
    ENABLE=1; wait_ticks(2); ENABLE=0;
    STATUS=5; BPM=999; check(BPM==240,7);
    ENABLE=1; wait_ticks(3); ENABLE=0;

    // Rounded period, read-only TICKS
    STATUS=6; BPM=137; check(BPM==137,8);
    ENABLE=1; wait_ticks(4); ENABLE=0;
    TICKS=0xffffffffu;
    check(TICKS==4,9);
    check(REG(0x1000c)==0,10);
    STATUS=0x600d0000u|checks;
    for (;;) __asm__ volatile("nop");
}
