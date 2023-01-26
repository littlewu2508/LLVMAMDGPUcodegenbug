# Reproducing Unsupported calling convention when generating AMDGPU object from bitcode for opencl

Original issue: https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/issues/45

## How to reproduce

Simply install llvm/clang with `clang` and `llvm-link` in `${PATH}` and run `./run.sh`

## Bug description

Desired result: all commands run successfully. This can be achieved by using [ROCm forked llvm](https://github.com/RadeonOpenCompute/llvm-project/)

```
+ AMDGPU_ARCH=gfx803
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source.cl -o GPUBitcode.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode.bc -o GPUkernel.o
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source1.cl -o GPUBitcode1.bc
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source2.cl -o GPUBitcode2.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode1.bc -o GPUkernel1.o
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode2.bc -o GPUkernel2.o
+ llvm-link GPUBitcode1.bc GPUBitcode2.bc -o GPUBitcode-linked.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode-linked.bc -o GPUkernel-linked.o
```

Actual result, using vanilla llvm/clang :

```
+ AMDGPU_ARCH=gfx803
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source.cl -o GPUBitcode.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode.bc -o GPUkernel.o
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source1.cl -o GPUBitcode1.bc
+ clang -cc1 -emit-llvm-bc -triple amdgcn-amd-amdhsa -target-cpu gfx803 -O3 -std=cl1.2 source2.cl -o GPUBitcode2.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode1.bc -o GPUkernel1.o
fatal error: error in backend: Unsupported calling convention for call
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode2.bc -o GPUkernel2.o
+ llvm-link GPUBitcode1.bc GPUBitcode2.bc -o GPUBitcode-linked.bc
+ clang -cc1 -emit-obj -triple amdgcn-amd-amdhsa -target-cpu gfx803 GPUBitcode-linked.bc -o GPUkernel-linked.o
fatal error: error in backend: Unsupported calling convention for call
```

