#!/usr/bin/env bash
# generate_hls.sh
# Generate both kernels and the full array function
# OlexandrI.B

set -euo pipefail
cd "$(dirname "$0")/.."
: "${BAMBU:?Set BAMBU to the Bambu 2024.10 executable or launcher}"
mkdir -p evidence/logs hls_plain hls_pipeline array_hls
for variant in plain pipeline; do
    flags=()
    if [[ "$variant" == pipeline ]]; then flags+=(-DPIPELINED); fi
    (cd "hls_$variant"
     "$BAMBU" ../cpp/max8.cpp "${flags[@]}" --top-fname=max8 \
        --compiler=I386_CLANG16 --device-name=5CSEMA5F31C6 --clock-period=5 \
        --registered-inputs=top --reset-type=async --reset-level=high \
        > "../evidence/logs/hls_max8_$variant.log" 2>&1)
    python3 scripts/prefix_modules.py "$variant"
done
(cd array_hls
 "$BAMBU" ../cpp/moving_max.cpp ../cpp/max8.cpp -I../cpp --top-fname=moving_max \
    --compiler=I386_CLANG16 --device-name=5CSEMA5F31C6 --clock-period=5 \
    --generate-interface=INFER --reset-type=async --reset-level=high \
    > ../evidence/logs/hls_array.log 2>&1)
