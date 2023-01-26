#define FOO 1

void kernel source2(__global int *j) { *j = FOO; }

void kernel source1(__global int *j) {
  *j += 2;
  source2(j);
}
