#!/usr/bin/env bash
# run_simulation.sh
# Run Nios V testbench
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
: "${SALT_LICENSE_SERVER:?Set SALT_LICENSE_SERVER to your own Questa license file}"
mkdir -p task2_nios/sim_work
cp task2_nios/software/simulation.hex task2_nios/sim_work/firmware.hex
cp task2_nios/software/simulation.dat task2_nios/sim_work/firmware.dat
cd task2_nios/sim_work
vsim -c -do ../../scripts/sim_nios.tcl > ../../evidence/logs/nios_simulation.log 2>&1
grep 'ALL TESTS PASSED' ../../evidence/logs/nios_simulation.log
wlf2vcd -o ../../evidence/nios_simulation.vcd ../../evidence/nios_simulation.wlf
gzip -f ../../evidence/nios_simulation.vcd
