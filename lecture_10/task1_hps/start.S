// start.S
// Cortex-A9 startup in OCRAM
// OlexandrI.B

.syntax unified
.arm
.section .init,"ax",%progbits
.global _start
_start:
    /* Debugger/preloader entry: privileged ARM state, MMU and caches off,
       FPGA configured, 50 MHz fabric clock and lightweight bridge enabled. */
    cpsid if
    ldr sp, =__stack_top
    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0
1:  cmp r0, r1
    strlo r2, [r0], #4
    blo 1b
    bl main
2:  b 2b
