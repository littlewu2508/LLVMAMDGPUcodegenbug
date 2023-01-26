#!/bin/bash -x

AMDGPU_ARCH=gfx803

clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source.cl -o GPUBitcode.bc
clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} GPUBitcode.bc -o GPUkernel.o

clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source1.cl -o GPUBitcode1.bc
clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source2.cl -o GPUBitcode2.bc
clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} GPUBitcode1.bc -o GPUkernel1.o
clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} GPUBitcode2.bc -o GPUkernel2.o

llvm-link GPUBitcode1.bc GPUBitcode2.bc -o GPUBitcode-linked.bc
clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu ${AMDGPU_ARCH} GPUBitcode-linked.bc -o GPUkernel-linked.o
