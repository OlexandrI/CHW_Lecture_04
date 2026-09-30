#!/usr/bin/env bash
# compile_fpga.sh
# Compile both Quartus projects
# OlexandrI.B

set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
task=${1:?usage: compile_fpga.sh task1_hps|task2_nios}
case "$task" in
 task1_hps) project=hps_chaser;;
 task2_nios) project=nios_chaser;;
 *) exit 2;;
esac
# Quartus 25.1's flow script corrupts non-ASCII current-directory names.
# Stage the same sources in an ASCII directory, then retain real reports.
build=$(mktemp -d "/tmp/lecture10_${task}.XXXXXX")
printf '%s\n' "$build" > "$root/evidence/${task}_build_directory.txt"
mkdir -p "$build/$task" "$build/shared"
cp "$root/shared/"* "$build/shared/"
rsync -a --exclude sim_work --exclude db --exclude incremental_db --exclude output_files \
    "$root/$task/" "$build/$task/"
cd "$build/$task"
if [[ $task == task1_hps ]]; then
    # HPS DDR pins have mandatory generated IO-standard/termination assignments.
    quartus_map "$project" > "$root/evidence/logs/hps_pre_map.log" 2>&1
    quartus_sta -t hps_system/synthesis/submodules/hps_sdram_p0_pin_assignments.tcl "$project" \
        > "$root/evidence/logs/hps_ddr_assignments.log" 2>&1
    cp "$project.qsf" "$root/$task/$project.qsf"
fi
set +e
quartus_sh --flow compile "$project" > "$root/evidence/logs/${task}_quartus.log" 2>&1
status=$?
set -e
if [[ -d output_files ]]; then
    mkdir -p "$root/$task/output_files"
    cp output_files/* "$root/$task/output_files/"
    mkdir -p "$root/evidence/reports/$task"
    for suffix in flow.rpt fit.summary map.summary sta.summary sta.rpt asm.rpt; do
        if [[ -f output_files/$project.$suffix ]]; then
            cp "output_files/$project.$suffix" "$root/evidence/reports/$task/"
        fi
    done
fi
tail -15 "$root/evidence/logs/${task}_quartus.log"
exit "$status"
