#!/usr/bin/env bash
# run_tests.sh
# C++ tests and C/RTL comparison in Questa
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p software_work evidence/logs
for variant in plain pipeline; do
    flags=()
    if [[ "$variant" == pipeline ]]; then flags+=(-DPIPELINED); fi
    g++ -std=c++17 -Wall -Wextra -Werror -Wno-unknown-pragmas \
        -fsanitize=address,undefined "${flags[@]}" -Icpp \
        cpp/moving_max.cpp cpp/max8.cpp tests/tb_moving_max.cpp -o "software_work/test_$variant"
    ASAN_OPTIONS=detect_leaks=0 "software_work/test_$variant" > "evidence/logs/cpp_$variant.log" 2>&1
    rg 'ALL C\+\+ TESTS PASSED' "evidence/logs/cpp_$variant.log"
done
export SALT_LICENSE_SERVER="${SALT_LICENSE_SERVER:-${SALT_LICENSE_FILE:-}}"
: "${SALT_LICENSE_SERVER:?Set your Questa license path or server}"
for variant in plain pipeline; do
    mkdir -p "sim_$variant"
    (cd "sim_$variant"; vsim -c -do "set variant $variant; do ../scripts/simulate.do" > "../evidence/logs/rtl_$variant.log" 2>&1)
    rg 'ALL RTL TESTS PASSED' "evidence/logs/rtl_$variant.log"
done
mkdir -p sim_array
(cd sim_array; vsim -c -do ../scripts/simulate_array.do > ../evidence/logs/rtl_array.log 2>&1)
rg 'ALL ARRAY TESTS PASSED' evidence/logs/rtl_array.log
