#!/usr/bin/env bash
# build.sh
# Compile all Quartus projects and package the IP
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence/logs evidence/reports
for variant in plain pipeline array; do
    dir="$variant"
    if [[ "$variant" == array ]]; then dir=array_hls; fi
    (cd "$dir"; quartus_sh --flow compile "moving_max_$variant" > "../evidence/logs/quartus_$variant.log" 2>&1)
    for suffix in fit.summary fit.rpt sta.summary; do
        cp "$dir/output_files/moving_max_$variant.$suffix" evidence/reports/
    done
done
qsys-script '--search-path=ip/**/*,$' --script=scripts/create_system.tcl > evidence/logs/package_ip.log 2>&1
qsys-generate moving_max_system.qsys --synthesis=VERILOG --simulation=VERILOG \
    '--search-path=ip/**/*,$' > evidence/logs/package_generate.log 2>&1
if rg -n 'Error:' evidence/logs/package_ip.log evidence/logs/package_generate.log; then exit 1; fi
python3 scripts/package_ip.py
