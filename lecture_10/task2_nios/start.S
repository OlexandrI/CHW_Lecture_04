// start.S
// Nios V startup and trap handler
// OlexandrI.B

.section .init,"ax",@progbits
.globl _start
_start:
    .option push
    .option norelax
    la sp, __stack_top
    la gp, __global_pointer$
    .option pop
    csrw mie, zero
    la t0, trap
    csrw mtvec, t0
    la t0, __bss_start
    la t1, __bss_end
1:  bgeu t0, t1, 2f
    sw zero, 0(t0)
    addi t0, t0, 4
    j 1b
2:  call main
3:  j 3b
.balign 4
trap:
    /* Visible fatal marker, monitored by the HDL testbench. */
    li t0, 0x10080
    li t1, 0xdead0000
    sw t1, 0(t0)
4:  j 4b
