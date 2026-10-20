# package_ip.py
# Sources and Platform Designer components in one archive
# OlexandrI.B

from pathlib import Path
import zipfile

files=[*Path('ip').glob('*_hw.tcl'),Path('rtl/moving_max_ip.sv'),
       Path('hls_plain/max8.v'),Path('hls_pipeline/max8.v'),Path('LICENSE_BAMBU_LIBRARY.txt')]
for p in files:
    if not p.is_file(): raise FileNotFoundError(p)
with zipfile.ZipFile('evidence/moving_max_ip.zip','w',zipfile.ZIP_DEFLATED) as z:
    for p in files: z.write(p,p.as_posix())
print('Packaged',len(files),'files: evidence/moving_max_ip.zip')
