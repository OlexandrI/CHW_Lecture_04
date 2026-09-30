#!/usr/bin/env bash
# build_software.sh
# Build ARM and Nios V programs
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p task{1_hps,2_nios}/software evidence/logs
if command -v ld.lld >/dev/null; then
    linker=$(command -v ld.lld)
else
    linker=$(find "$HOME/.rustup/toolchains" -path '*/bin/rust-lld' -type f | sort | head -1)
fi
test -n "$linker"
common=(-Os -g -ffreestanding -fno-builtin -fno-stack-protector -fno-unwind-tables -fno-asynchronous-unwind-tables -Wall -Wextra -Werror -Ishared)
for mode in hardware simulation; do
    extra=()
    if [[ $mode == simulation ]]; then extra=(-DSIMULATION); fi
    for src in main chaser; do
        clang --target=riscv32-unknown-elf -march=rv32i_zicsr -mabi=ilp32 -mno-relax "${common[@]}" "${extra[@]}" -c "shared/$src.c" -o "task2_nios/software/${src}_${mode}.o"
    done
    clang --target=riscv32-unknown-elf -march=rv32i_zicsr -mabi=ilp32 -mno-relax -c task2_nios/start.S -o task2_nios/software/start.o
    "$linker" -flavor gnu -m elf32lriscv -T task2_nios/link.ld --no-relax -Map="task2_nios/software/${mode}.map" -o "task2_nios/software/${mode}.elf" task2_nios/software/start.o "task2_nios/software/main_${mode}.o" "task2_nios/software/chaser_${mode}.o"
    llvm-objcopy -O binary "task2_nios/software/${mode}.elf" "task2_nios/software/${mode}.bin"
    echo "Built Nios V/m $mode ELF"
    llvm-size "task2_nios/software/${mode}.elf"
done
for src in main chaser; do
    clang --target=arm-none-eabi -mcpu=cortex-a9 -mfloat-abi=soft -DHPS "${common[@]}" -c "shared/$src.c" -o "task1_hps/software/$src.o"
done
clang --target=arm-none-eabi -mcpu=cortex-a9 -c task1_hps/start.S -o task1_hps/software/start.o
"$linker" -flavor gnu -m armelf -T task1_hps/link.ld -Map=task1_hps/software/hps.map -o task1_hps/software/hps.elf task1_hps/software/start.o task1_hps/software/main.o task1_hps/software/chaser.o
echo 'Built HPS Cortex-A9 ELF (OCRAM debugger/preloader payload)'
llvm-size task1_hps/software/hps.elf
llvm-readelf -h task2_nios/software/simulation.elf
llvm-readelf -h task1_hps/software/hps.elf
python3 scripts/memory_image.py
sha256sum task2_nios/software/*.elf task1_hps/software/*.elf
