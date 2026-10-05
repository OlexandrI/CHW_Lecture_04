#!/usr/bin/env bash
# build_software.sh
# Build a real RISC-V ELF for Nios V/m
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p software evidence/logs
flags=(--target=riscv32-unknown-elf -march=rv32i_zicsr -mabi=ilp32 -mno-relax)
clang "${flags[@]}" -c software/start.S -o software/start.o
if command -v ld.lld >/dev/null; then linker=$(command -v ld.lld); else
    linker=$(find "$HOME/.rustup/toolchains" -path '*/bin/rust-lld' -type f | sort | head -1)
fi
for mode in hardware simulation; do
    extra=()
    if [[ $mode == simulation ]]; then extra=(-DSIMULATION); fi
    clang "${flags[@]}" "${extra[@]}" -Os -g -ffreestanding -fno-builtin -fno-stack-protector -Wall -Wextra -Werror -c software/main.c -o "software/$mode.o"
    "$linker" -flavor gnu -m elf32lriscv -T software/link.ld --no-relax -Map="software/$mode.map" -o "software/$mode.elf" software/start.o "software/$mode.o"
    llvm-objcopy -O binary "software/$mode.elf" "software/$mode.bin"
    llvm-size "software/$mode.elf"
    llvm-readelf -h "software/$mode.elf"
    sha256sum "software/$mode.elf"
done
python3 scripts/memory_image.py
cp software/hardware.hex firmware.hex
