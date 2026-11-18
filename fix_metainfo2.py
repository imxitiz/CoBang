line = '          <p>Floating point exception & heap corruption crash fixes.</p>\n'
print('len:', len(line))
print('hex:', line.encode().hex())
with open('data/vn.hoabinh.quan.CoBang.metainfo.xml.in', 'r') as f:
    lines = f.readlines()
lines[122] = line
with open('data/vn.hoabinh.quan.CoBang.metainfo.xml.in', 'w') as f:
    f.writelines(lines)