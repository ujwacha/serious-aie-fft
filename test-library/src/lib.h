#ifndef TEST_LIBRARY_LIB_H
#define TEST_LIBRARY_LIB_H

#include <stddef.h>
#include <stdint.h>


// our data
// 2048
// 128 of them

#define TOTAL_SEQUENCE 128
#define BURST_LEN 16


typedef struct {
  int16_t real;
  int16_t imag;
} cint16;

typedef struct {
  uint64_t high;
  uint64_t low;
} rmask;
typedef uint16_t dmask;
typedef uint8_t amask;


typedef union {
  rmask mt[TOTAL_SEQUENCE];
  dmask md[TOTAL_SEQUENCE];
  amask ma[TOTAL_SEQUENCE];
} mask;


typedef struct {
  mask m;
  cint16 *head_pointer[TOTAL_SEQUENCE];
  cint16 *space;
  uint32_t len;
} allocation;

typedef struct {
  cint16 data[BURST_LEN];
} burst;

typedef struct {
  burst data;
  uint32_t next;
} block;

#endif /* TEST_LIBRARY_LIB_H */
