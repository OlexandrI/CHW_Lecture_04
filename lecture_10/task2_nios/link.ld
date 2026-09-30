/* link.ld
 * Nios V program in 32 KiB RAM
 * OlexandrI.B
 */

ENTRY(_start)
MEMORY { ram (rwx) : ORIGIN = 0, LENGTH = 32K }
SECTIONS {
    .text : { KEEP(*(.init)) *(.text*) *(.rodata*) } > ram
    .data : { *(.data*) *(.sdata*) } > ram
    . = ALIGN(4);
    __global_pointer$ = . + 0x800;
    .bss (NOLOAD) : { __bss_start = .; *(.bss*) *(.sbss*) *(COMMON) . = ALIGN(4); __bss_end = .; } > ram
    __stack_top = ORIGIN(ram) + LENGTH(ram);
    ASSERT(__bss_end < __stack_top - 4096, "Not enough stack space")
}
