/*
 * Downloaded from http://www.createwindow.com/programming/crc32/index.htm
 * 11 Feb 2012
 * Version of CRC-32 function that matched AC34 output.
 *
 * This version is like the 'standard' version in crc32-a.cc, except
 * that the CRC table is computed with all the 'bits' reflected from
 * the standard version; if you therefore 'reflect' the polynomial
 * value, you will get the same table as the 'standard' version.
 *
 * Note that you have to use the uint32_t type, not unsigned long, as
 * many modern machines have 64-bit longs.
 */

#include <assert.h>
#include <stdint.h>
#include "stdio.h"

/* crc32table[] built by crc32_init() */
static uint32_t crc32_table[256];

/* Calculate crc32. Little endian.
 * Standard seed is 0xffffffff or 0.
 * Some implementations xor result with 0xffffffff after calculation. */
uint32_t crc32 (unsigned char *data, unsigned int len)
{
  uint32_t  ulCRC(0xFFffFFff); 

  /* Careful! unsigned long is 64 bits on my macbook */
  // printf("sizeof long: %ld\n", sizeof(unsigned long));
  // printf("sizeof uint32_t: %ld\n", sizeof(uint32_t));
  // assert(sizeof(unsigned long)==4);

  while(len--) {
    assert((ulCRC & 0xFF) < sizeof(crc32_table));
    unsigned char c = *data++;
    //ulCRC = (ulCRC >> 8) ^ crc32_table[(ulCRC & 0xFF) ^ *data++];
    ulCRC = (ulCRC >> 8) ^ crc32_table[(ulCRC & 0xFF) ^ c]; 
  }
  // Exclusive OR the result with the beginning value. 
  return ulCRC ^ 0xFFffFFff;   
  
}

uint32_t reflect(uint32_t ref, char ch) 
{
  uint32_t value(0);
  
  // Swap bit 0 for bit 7 
  // bit 1 for bit 6, etc. 
  for(int i = 1; i < (ch + 1); i++) 
    { 
      if(ref & 1) 
	value |= 1 << (ch - i); 
      ref >>= 1; 
    } 
  return value; 
}

/* Calculate crc32table */
void crc32_init()
{
  uint32_t ulPolynomial = 0x04c11db7;
  uint32_t xor_mask;

  // 256 values representing ASCII character codes. 
  for(int i = 0; i <= 0xFF; i++) 
    { 
      assert(i < sizeof(crc32_table));

      crc32_table[i]=reflect(i, 8) << 24; 
      for (int j = 0; j < 8; j++) { 
	// crc32_table[i] = (crc32_table[i] << 1) ^ (crc32_table[i] & (1 << 31) ? ulPolynomial : 0); 
	if (crc32_table[i] & (1 << 31))
	  xor_mask = ulPolynomial;
	else
	  xor_mask = 0;
	crc32_table[i] = (crc32_table[i] << 1) ^ xor_mask;
      }
      crc32_table[i] = reflect(crc32_table[i], 32); 
    } 
  
}


int
main(int argc, char **argv)
{
  crc32_init();
  printf("TABLE\n");
  for (int i = 0; i < 256; i++)
    printf("%8x   %8x\n", crc32_table[i], reflect(crc32_table[i], 32));
  printf("\n");

  unsigned char buf[1024];
  int n = fread(buf, 1, 1024, stdin);
  printf("Read %d\n", n);

  assert(reflect(1, 0) == 0);
  assert(reflect(1, 1) == 1);
  assert(reflect(0, 2) == 0);
  assert(reflect(1, 2) == 2);
  assert(reflect(2, 2) == 1);
  assert(reflect(0xFF00, 16) == 0xff);
  assert(reflect(0x0F00, 16) == 0xf0);

  uint32_t crc = crc32(buf, n);
  printf("%x\n", crc);
  
}
