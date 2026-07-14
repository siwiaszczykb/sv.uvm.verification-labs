# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/dut.sv
VERILOG_SOURCES += $(PWD)/24CSM01.sv
VERILOG_SOURCES += $(PWD)/controller.sv

COCOTB_TOPLEVEL = dut
COCOTB_TEST_MODULES = test

include $(shell cocotb-config --makefiles)/Makefile.sim