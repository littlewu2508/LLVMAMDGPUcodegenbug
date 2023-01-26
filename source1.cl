#include "include-a.h"

void kernel source1(__global int *j) {
  *j += 2;
  source2(j);
}
