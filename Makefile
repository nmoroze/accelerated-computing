CXX ?= g++
NVCC ?= nvcc

CXXFLAGS ?= -O3 -std=c++17 -Wall -Wextra -pedantic -march=native
NVCCFLAGS ?= -O3 -std=c++17

CPU_BIN := mandelbrot_cpu
GPU_BIN := mandelbrot_gpu

.PHONY: all clean

all: $(CPU_BIN) $(GPU_BIN)

$(CPU_BIN): mandelbrot_cpu.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

$(GPU_BIN): mandelbrot_gpu.cu
	$(NVCC) $(NVCCFLAGS) -o $@ $<

clean:
	rm -f $(CPU_BIN) $(GPU_BIN)
