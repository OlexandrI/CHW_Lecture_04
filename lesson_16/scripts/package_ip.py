# package_ip.py
# Sources and component description for IP reuse
# OlexandrI.B

from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

with ZipFile('results/metronome_ip.zip','w',ZIP_DEFLATED) as z:
    for name in ['metronome.v','metronome_hw.tcl']:
        p=Path('ip')/name
        z.write(p,p.as_posix())
print('Packaged metronome IP: results/metronome_ip.zip')
