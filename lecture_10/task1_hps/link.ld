/* link.ld
 * HPS program in 64 KiB OCRAM
 * OlexandrI.B
 */

ENTRY(_start)
MEMORY { ocram (rwx) : ORIGIN = 0xffff0000, LENGTH = 64K }
SECTIONS {
    .text : { KEEP(*(.init)) *(.text*) *(.rodata*) } > ocram
    .ARM.exidx : { *(.ARM.exidx*) } > ocram
    .data : { *(.data*) } > ocram
    .bss (NOLOAD) : { . = ALIGN(4); __bss_start = .; *(.bss*) *(COMMON) . = ALIGN(4); __bss_end = .; } > ocram
    __stack_top = 0xfffffff0;
    ASSERT(__bss_end < __stack_top - 4096, "Not enough stack space")
}
