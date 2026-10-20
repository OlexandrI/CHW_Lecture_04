#!/usr/bin/env bash
# build.sh
# Compile the four lesson 7 projects
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")"
for pair in part1_lock:lock_controller part2_alu:alu part3_plain:expr_plain part3_pipeline:expr_pipelined; do
    folder=${pair%:*}
    project=${pair#*:}
    (
        cd "$folder"
        mkdir -p evidence
        quartus_sh --flow compile "$project" > evidence/quartus.log 2>&1
        cp output_files/*.sta.rpt output_files/*.sta.summary output_files/*.flow.rpt output_files/*.fit.summary output_files/*.map.summary evidence/
    )
done
