#include "main.h"

#include "lib.h"

#include <stdio.h>

void say_hello(void) { puts("Hello, World!"); }

int main(void) {
    char buf[128];

    say_hello();

    /* Touch the library so the build proves both translation units link. */
    if (testlib_greet(buf, sizeof buf, testlib_name()) > 0)
        printf("%s v%s\n", buf, testlib_version());

    return 0;
}
