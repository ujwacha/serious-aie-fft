#include "complex-math.h"

cint16 bits_to_cint16(ap_uint<32> bits) {
  cint16 c;
  c.real = (short)bits.range(15, 0);  // low 16 = I
  c.imag = (short)bits.range(31, 16); // high 16 = Q
  return c;
}

ap_uint<32> cint16_to_bits(cint16 c) {
  ap_uint<32> bits;
  bits.range(15, 0) = (ap_uint<16>)(ap_int<16>)c.real;
  bits.range(31, 16) = (ap_uint<16>)(ap_int<16>)c.imag;
  return bits;
}

cint16 cmul(cint16 a, cint16 b) {
  cint16 r;
  r.real = (a.real * b.real - a.imag * b.imag) >> 15;
  r.imag = (a.real * b.imag + a.imag * b.real) >> 15;
  return r;
}
