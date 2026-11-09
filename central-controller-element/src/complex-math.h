#ifndef COMPLEX_MATH_H
#define COMPLEX_MATH_H

#include <ap_axi_sdata.h>

#include "hamming.h"

/* cint16 <-> packed 32-bit word: low 16 bits = I, high 16 bits = Q. */
cint16 bits_to_cint16(ap_uint<32> bits);
ap_uint<32> cint16_to_bits(cint16 c);

/* Q15 complex multiply: (a * b) >> 15 per component. */
cint16 cmul(cint16 a, cint16 b);

#endif /* COMPLEX_MATH_H */
