
RTL_LOG = log/rtl.log
VERIFY_LOG = log/verify.log
ELAB_LOG = log/elab.log
SIM_LOG = log/sim.log

WAVE ?= 0
COV ?= 0
VERB ?= UVM_LOW
TEST ?=

ifeq ($(WAVE), 1)
    ELAB_DEBUG = -debug typical
    SIM_CMD = echo "log_wave -r /; run all; exit" > wave.tcl && xsim top_tb_snap -tclbatch wave.tcl -testplusarg UVM_VERBOSITY=$(VERB) UVM_TESTNAME=$(TEST)
else
    ELAB_DEBUG =
    SIM_CMD = xsim top_tb_snap -R -testplusarg UVM_VERBOSITY=$(VERB) UVM_TESTNAME=$(TEST)
endif

ifeq ($(COV), 1)
    XELAB_COV_FLAGS = -cc_type sbct -cc_dir cov -cov_db_name top_cov
else
    XELAB_COV_FLAGS =
endif

.PHONY: all clean init comp_rtl comp_tb elab run report

all: clean init comp_rtl comp_tb elab run report

init:
	mkdir -p log
	mkdir -p cov

comp_rtl:
	xvlog -sv -work work -L uvm -f rtl.f 2>&1 | tee -a $(RTL_LOG) | grep -iE "error|warning" || true

comp_tb:
	xvlog -sv -work work -L uvm -f verif.f 2>&1 | tee -a $(VERIFY_LOG) | grep -iE "error|warning" || true

elab:
	xelab -top work.top -snapshot top_tb_snap -L uvm -timescale 1ns/10ps $(ELAB_DEBUG) $(XELAB_COV_FLAGS) 2>&1 | tee -a $(ELAB_LOG) | grep -iE "error|warning" || true

run:
	$(SIM_CMD) | tee -a $(SIM_LOG) | grep -iE "error|warning" || true

report:
ifeq ($(COV), 1)
	mkdir -p cov/report
	xcrg -cov_db_dir cov -cov_db_name top_cov -report_dir cov/report -report_format html
endif

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb wave.tcl
	rm -rf verify/xsim.dir verify/*.log verify/*.jou verify/*.pb verify/*.wdb
	rm -rf log cov