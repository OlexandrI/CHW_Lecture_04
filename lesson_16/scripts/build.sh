#!/usr/bin/env bash
# build.sh
# Build firmware, generate the system and compile both projects
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p results/logs results/reports
bash scripts/build_software.sh > results/logs/software_build.log 2>&1
qsys-script '--search-path=ip,$' --script=scripts/create_system.tcl > results/logs/create_system.log 2>&1
if rg -n 'Error:' results/logs/create_system.log; then exit 1; fi
qsys-generate metronome_system.qsys --synthesis=VERILOG --simulation=VERILOG \
    '--search-path=ip,$' > results/logs/generate_system.log 2>&1
quartus_sh --flow compile metronome > results/logs/quartus_system.log 2>&1
(cd ip_only; quartus_sh --flow compile metronome_ip > ../results/logs/quartus_ip.log 2>&1)
for suffix in fit.summary fit.rpt sta.summary; do
    cp "output_files/metronome.$suffix" results/reports/
    cp "ip_only/output_files/metronome_ip.$suffix" results/reports/
done
python3 scripts/package_ip.py
