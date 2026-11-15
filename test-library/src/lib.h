#ifndef TEST_LIBRARY_LIB_H
#define TEST_LIBRARY_LIB_H

#include <stddef.h>

const char *testlib_name(void);
const char *testlib_version(void);

/* Writes "greetings from <who>" into buf and returns the snprintf-style
 * length. A non-positive return means the buffer was too small or invalid. */
int testlib_greet(char *buf, size_t size, const char *who);

#endif /* TEST_LIBRARY_LIB_H */
