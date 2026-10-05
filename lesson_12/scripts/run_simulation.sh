#!/usr/bin/env bash
# run_simulation.sh
# Unit test and complete Nios V / DMA simulation
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
: "${SALT_LICENSE_SERVER:?Set SALT_LICENSE_SERVER to your own Questa license}"
mkdir -p unit_work sim_work evidence/logs
cp software/simulation.hex sim_work/firmware.hex
cp software/simulation.dat sim_work/firmware.dat
(cd unit_work; vsim -c -do ../scripts/unit_sim.do > ../evidence/logs/receiver_simulation.log 2>&1)
rg 'ALL RECEIVER TESTS PASSED' evidence/logs/receiver_simulation.log
(cd sim_work; vsim -c -do ../scripts/system_sim.do > ../evidence/logs/system_simulation.log 2>&1)
rg 'ALL SYSTEM TESTS PASSED' evidence/logs/system_simulation.log
