# prefix_modules.py
# Separate module names for the two generated kernels
# OlexandrI.B

from pathlib import Path
import re
import sys

variant=sys.argv[1]
p=Path(f'hls_{variant}/max8.v')
s=p.read_text()
names=re.findall(r'^module\s+(\w+)',s,re.M)
mapping={n: f'{variant}_{n}' for n in names}
mapping['_Z4max8iiiiiiii']=f'max8_{variant}'
s=re.sub(r'\b(?:'+ '|'.join(map(re.escape,names))+r')\b',lambda m:mapping[m[0]],s)
p.write_text('// Module names prefixed by scripts/prefix_modules.py\n'+s)
