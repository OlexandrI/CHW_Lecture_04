# memory_image.py
# Convert ELF binary to RAM files
# OlexandrI.B

"""Convert the linked ELF's objcopy binary into Intel HEX and readmemh DAT.

ELF PT_LOAD image begins at address zero (checked using llvm-readelf).
Intel on-chip RAM HEX uses 32-bit words as its address units.
"""
from pathlib import Path
import struct

def record(address, kind, payload):
    raw=bytes([len(payload), address >> 8, address & 255, kind])+payload
    return ':'+raw.hex().upper()+f'{(-sum(raw))&255:02X}'

base=Path('task2_nios/software')
for mode in ('hardware','simulation'):
    elf=(base/f'{mode}.elf').read_bytes()
    assert elf[:6]==b'\x7fELF\x01\x01', 'expected little-endian ELF32'
    header=struct.unpack_from('<HHIIIIIHHHHHH',elf,16)
    machine,entry,phoff,phsize,phnum=header[1],header[3],header[4],header[8],header[9]
    assert machine==243 and entry==0, 'expected RISC-V entry at RAM address zero'
    loads=[]
    for idx in range(phnum):
        kind,offset,vaddr,paddr,filesz,memsz,flags,alignment=struct.unpack_from('<IIIIIIII',elf,phoff+idx*phsize)
        if kind==1:
            assert paddr==vaddr and paddr+memsz<=32768
            loads.append((paddr,elf[offset:offset+filesz]))
    data=(base/f'{mode}.bin').read_bytes()
    assert len(data)<=32768
    assert min(addr for addr,chunk in loads)==0
    for addr,chunk in loads:
        assert data[addr:addr+len(chunk)]==chunk, 'objcopy image differs from ELF PT_LOAD segment'
    data=data.ljust(32768,b'\x00')
    words=struct.unpack('<8192I',data)
    (base/f'{mode}.dat').write_text('@00000000\n'+'\n'.join(f'{w:08x}' for w in words)+'\n')
    (base/f'{mode}.hex').write_text('\n'.join(record(i,0,w.to_bytes(4,'big')) for i,w in enumerate(words))+'\n:00000001FF\n')
    print(f'{mode}: ELF -> binary -> {len(words)} x 32-bit words, HEX + DAT')
