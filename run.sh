#!/bin/bash -x

AMDGPU_ARCH=gfx803
TRIPLE=amdgcn-amd-amdhsa

echo "Compile complete opencl code into object, step-by-step (source->bitcode->object)"
clang -cc1 -emit-llvm-bc -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source.cl -o GPUBitcode.bc
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} GPUBitcode.bc -o GPUkernel.o

echo "Compile separated opencl code into object, step-by-step (source->bitcode->object)"
clang -cc1 -emit-llvm-bc -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source1.cl -o GPUBitcode1.bc
clang -cc1 -emit-llvm-bc -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} -O3 -std=cl1.2 source2.cl -o GPUBitcode2.bc
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} GPUBitcode1.bc -o GPUkernel1.o
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} GPUBitcode2.bc -o GPUkernel2.o

echo "Compile separated opencl code into object, one-step (source->object)"
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} source1.cl -o GPUkernel1.o
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} source2.cl -o GPUkernel2.o

echo "linked opencl bitcode and then compile into object, (bitcode->object)"
llvm-link GPUBitcode1.bc GPUBitcode2.bc -o GPUBitcode-linked.bc
clang -cc1 -emit-obj -triple ${TRIPLE} -target-cpu ${AMDGPU_ARCH} GPUBitcode-linked.bc -o GPUkernel-linked.o
