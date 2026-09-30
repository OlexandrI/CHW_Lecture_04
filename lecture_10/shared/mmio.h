// mmio.h
// PIO and timer registers
// OlexandrI.B

#ifndef MMIO_H
#define MMIO_H
#include <stdint.h>

// Same peripheral map, HPS adds lightweight bridge base
#ifdef HPS
#define IO_BASE 0xff200000u
#else
#define IO_BASE 0u
#endif
enum {
    LEDS = 0x10000,
    BUTTONS = 0x10010,
    SWITCHES = 0x10020,
    MOVE_TIMER = 0x10040,
    SCAN_TIMER = 0x10060,
    DEBUG_PIO = 0x10080
};
enum { TIMER_STATUS = 0, TIMER_CONTROL = 4, TIMER_PERIODL = 8, TIMER_PERIODH = 12 };
enum { TIMER_TO = 1, TIMER_CONT = 2, TIMER_START = 4, TIMER_STOP = 8 };

// Volatile access, ARM barriers keep register accesses ordered
static inline uint32_t io_read(uint32_t address) {
    uint32_t v = *(volatile uint32_t *)(uintptr_t)(IO_BASE + address);
#ifdef HPS
    __asm__ volatile("dmb sy" ::: "memory");
#endif
    return v;
}
static inline void io_write(uint32_t address, uint32_t value) {
#ifdef HPS
    __asm__ volatile("dmb sy" ::: "memory");
#endif
    *(volatile uint32_t *)(uintptr_t)(IO_BASE + address) = value;
#ifdef HPS
    __asm__ volatile("dsb sy" ::: "memory");
#endif
}
#endif
