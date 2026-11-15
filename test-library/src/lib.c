#include "lib.h"

#include <stdio.h>

const char *testlib_name(void) { return "test-library"; }

const char *testlib_version(void) { return "0.1.0"; }

int testlib_greet(char *buf, size_t size, const char *who) {
    return snprintf(buf, size, "greetings from %s", who);
}
