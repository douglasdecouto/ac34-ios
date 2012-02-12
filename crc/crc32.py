"""
Python adaptation of standard CRC-32 code.

Adapted from the C++ code at below link, which produces results
matching test data from AC34.

 * http://www.createwindow.com/programming/crc32/index.htm

Here are some other CRC-32 implementations.  Their function is
replicated by the create_table_standard() function.  The difference is
that the version above version has all the bits 'reflected' in each of
the CRC table entries, and therefore needs a 'reflected' polynomial to
get the same results as the standard version.

 * http://damieng.com/blog/2006/08/08/calculating_crc32_in_c_and_net that         
 * http://gitorious.org/ransrid/ransrid/blobs/448e626e686599dff5c14e0fc2b5c60c8fba4ba8/crc32.c

"""
DEFAULT_POLYNOMIAL   = 0xedb88320 # Use with create_table_standard
REFLECTED_POLYNOMIAL = 0x04c11db7 # Use with create_table_reflected

def _reflect(val, width):
    new_val = 0
    for i in range(width):
        if val & 1:
            new_val |= (1 << (width - (i + 1)))
        val >>= 1
    return new_val

def _test_reflect():
    assert _reflect(1, 0) == 0
    assert _reflect(1, 1) == 1
    assert _reflect(0, 2) == 0
    assert _reflect(1, 2) == 2
    assert _reflect(2, 2) == 1
    assert _reflect(0xFF00, 16) == 0xff
    assert _reflect(0x0F00, 16) == 0xf0


class CRC32(object):
    def __init__(self, polynomial=DEFAULT_POLYNOMIAL):
        self.table = self.create_table_reflected(polynomial)
        self.table = self.create_table_standard(_reflect(polynomial, 32))

    def create_table_standard(self, poly):
        table = [0]*256;
        for i in range(256):
            entry = i
            for j in range(8):
                if (entry & 1) == 1:
                    entry = ((entry >> 1) ^ poly) & 0xFFffFFff
                else:
                    entry = (entry >> 1) & 0xFFffFFff
            table[i] = entry
        return table
    
    def create_table_reflected(self, poly):
        table = [0]*256;
        for i in range(256):
            table[i] = _reflect(i, 8) << 24
            for j in range(8):
                if table[i] & (1 << 31):
                    xor_mask = poly
                else:
                    xor_mask = 0
                table[i] = ((table[i] << 1) & 0xFFffFFff) ^ xor_mask
            table[i] = _reflect(table[i], 32)

        return table
    
    def hash(self, buf, cumulative_crc=0):
        crc = cumulative_crc ^ 0xFFffFFff
        for ch in buf:
            crc = ((crc >> 8) & 0xFFffFFff) ^ self.table[(crc & 0xff) ^ ord(ch)]

        return crc ^ 0xFFffFFff
