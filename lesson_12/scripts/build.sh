#!/usr/bin/env bash
# build.sh
# Generate firmware and system, then compile the FPGA project
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p evidence/logs evidence/reports
bash scripts/build_software.sh > evidence/logs/software_build.log 2>&1
qsys-script '--search-path=rtl/**/*,$' --script=scripts/create_system.tcl > evidence/logs/create_system.log 2>&1
if rg -q 'Error:' evidence/logs/create_system.log; then cat evidence/logs/create_system.log; exit 1; fi
qsys-generate frame_system.qsys --synthesis=VERILOG --simulation=VERILOG '--search-path=rtl/**/*,$' > evidence/logs/generate_system.log 2>&1
quartus_sh --flow compile frame_capture > evidence/logs/quartus.log 2>&1
cp output_files/*.sta.rpt output_files/*.sta.summary output_files/*.flow.rpt output_files/*.fit.summary output_files/*.map.summary evidence/reports/
