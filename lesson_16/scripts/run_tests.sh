#!/usr/bin/env bash
# run_tests.sh
# Unit PASS, deliberate FAIL and Nios V system simulation
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
export SALT_LICENSE_SERVER="${SALT_LICENSE_SERVER:-${SALT_LICENSE_FILE:-}}"
: "${SALT_LICENSE_SERVER:?Set your Questa license path or server}"
mkdir -p unit_work sim_work results/logs
if [[ ! -f software/simulation.hex || ! -f software/simulation.dat ]]; then
    bash scripts/build_software.sh > results/logs/software_build.log 2>&1
fi
(cd unit_work; vsim -c -do ../scripts/unit_sim.do > ../results/logs/unit_pass.log 2>&1)
rg 'ALL UNIT TESTS PASSED' results/logs/unit_pass.log
code=0
(cd unit_work; vsim -c -do 'set broken 1; do ../scripts/unit_sim.do' > ../results/logs/unit_fail.log 2>&1) || code=$?
if [[ $code -eq 0 ]] || ! rg -q 'FAIL scenario 1: tick at cycle 500: got 0 expected 1' results/logs/unit_fail.log; then
    echo 'FAIL: broken module was not rejected as expected'; exit 1
fi
echo 'PASS: the same testbench rejected the deliberate off-by-one error'
cp software/simulation.hex sim_work/firmware.hex
cp software/simulation.dat sim_work/firmware.dat
(cd sim_work; vsim -c -do ../scripts/system_sim.do > ../results/logs/system_simulation.log 2>&1)
rg 'ALL SYSTEM TESTS PASSED' results/logs/system_simulation.log
