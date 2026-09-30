#!/usr/bin/env bash
# view_wave.sh
# Open saved simulation waveform
# OlexandrI.B

set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
# Questa's library browser also has trouble with non-ASCII working directories.
# Use an unchanged copy of the saved result; this does not run the simulation.
viewer=$(mktemp -d /tmp/lecture10_wave.XXXXXX)
cp "$root/evidence/nios_simulation.wlf" "$viewer/nios_simulation.wlf"
cp "$root/scripts/view_wave.tcl" "$viewer/view_wave.tcl"
cd "$viewer"
exec vsim -gui -view nios_simulation.wlf -do view_wave.tcl
