# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
# Tool Version Limit: 2026.06
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
CSIM_DESIGN = 1

__SIM_FPO__ = 1

__SIM_MATHHLS__ = 1

__SIM_FFT__ = 1

__SIM_VRF_FFT__ = 1

__SIM_FIR__ = 1

__SIM_DDS__ = 1

__USE_CLANG__ = 1

ObjDir = obj

HLS_SOURCES = ../../../../tb/test.cpp ../../../../src/complex-math.cpp ../../../../src/angle_part.cpp ../../../../src/doppler_part.cpp ../../../../src/range_part.cpp ../../../../src/main.cpp

override TARGET := csim.exe

AUTOPILOT_ROOT := /home/light/FPGA/2026.1/Vitis
AUTOPILOT_MACH := lnx64
ifdef AP_GCC_M32
  AUTOPILOT_MACH := Linux_x86
  IFLAG += -m32
endif
IFLAG += -fPIC
ifndef AP_GCC_PATH
  AP_GCC_PATH := /home/light/FPGA/2026.1/Vitis/tps/lnx64/gcc-8.3.0/bin
endif
AUTOPILOT_TOOL := ${AUTOPILOT_ROOT}/${AUTOPILOT_MACH}/tools
AP_CLANG_PATH := ${AUTOPILOT_ROOT}/lnx64/tools/clang-16/bin
AUTOPILOT_TECH := ${AUTOPILOT_ROOT}/common/technology


IFLAG += -I "${AUTOPILOT_ROOT}/include"
IFLAG += -I "${AUTOPILOT_ROOT}/include/ap_sysc"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC/AESL_FP_comp"
IFLAG += -I "${AUTOPILOT_TECH}/generic/SystemC/AESL_comp"
IFLAG += -I "${AUTOPILOT_TOOL}/auto_cc/include"
IFLAG += -I "/usr/include/x86_64-linux-gnu"
IFLAG += -D__HLS_COSIM__

IFLAG += -D__HLS_CSIM__

IFLAG += -D__VITIS_HLS__

IFLAG += -D__SIM_FPO__

IFLAG += -D__SIM_FFT__

IFLAG += -D__SIM_VRF_FFT__

IFLAG += -D__SIM_FIR__

IFLAG += -D__SIM_DDS__

IFLAG += -D__DSP48E1__
IFLAG += -g
DFLAG += -D__xilinx_ip_top= -DAESL_TB
CCFLAG += -Werror=return-type
CCFLAG += -Wno-abi
CCFLAG += -fdebug-default-version=4
CCFLAG += --gcc-toolchain=/home/light/FPGA/2026.1/Vitis/tps/lnx64/gcc-8.3.0
CCFLAG += -Werror=uninitialized
CCFLAG += -Wno-c++11-narrowing
CCFLAG += -Wno-error=sometimes-uninitialized
LFLAG += --gcc-toolchain=/home/light/FPGA/2026.1/Vitis/tps/lnx64/gcc-8.3.0
LFLAG += -lstdc++fs



include ./Makefile.rules

all: $(TARGET)



$(ObjDir)/test.o: ../../../../tb/test.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../tb/test.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD -Wno-unknown-pragmas -Wno-unknown-pragmas  $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/test.d

$(ObjDir)/complex-math.o: ../../../../src/complex-math.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../src/complex-math.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD  -fhls-csim -fhlstoplevel=kernel $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/complex-math.d

$(ObjDir)/angle_part.o: ../../../../src/angle_part.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../src/angle_part.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD  -fhls-csim -fhlstoplevel=kernel $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/angle_part.d

$(ObjDir)/doppler_part.o: ../../../../src/doppler_part.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../src/doppler_part.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD  -fhls-csim -fhlstoplevel=kernel $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/doppler_part.d

$(ObjDir)/range_part.o: ../../../../src/range_part.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../src/range_part.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD  -fhls-csim -fhlstoplevel=kernel $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/range_part.d

$(ObjDir)/main.o: ../../../../src/main.cpp $(ObjDir)/.dir csim.mk
	$(Echo) "   Compiling ../../../../src/main.cpp in $(BuildMode) mode" $(AVE_DIR_DLOG)
	$(Verb)  $(CXX) -std=gnu++17 ${CCFLAG} -c -MMD  -fhls-csim -fhlstoplevel=kernel $(IFLAG) $(DFLAG) $< -o $@ ; \

-include $(ObjDir)/main.d
