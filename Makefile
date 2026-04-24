RTL_LOG = log/rtl.log
VERIFY_LOG = log/verify.log
ELAB_LOG = log/elab.log
SIM_LOG = log/sim.log

WAVE = 0

ifeq ($(WAVE), 1)
    ELAB_DEBUG = -debug typical
    SIM_CMD = echo "log_wave -r /; run all; exit" > wave.tcl && xsim top_tb_snap -tclbatch wave.tcl
else
    ELAB_DEBUG =
    SIM_CMD = xsim top_tb_snap -R
endif

all: comp_rtl comp_tb elab run

comp_rtl:
	xvlog -sv -work work -f rtl.f 2>&1 | tee -a $(RTL_LOG) | grep -iE "error|warning" || true

comp_tb:
	xvlog -sv -work work -f verif.f 2>&1 | tee -a $(VERIFY_LOG) | grep -iE "error|warning" || true

elab:
	xelab -top work.top -snapshot top_tb_snap $(ELAB_DEBUG) 2>&1 | tee -a $(ELAB_LOG) | grep -iE "error|warning" || true

run:
	$(SIM_CMD) | tee -a $(SIM_LOG) | grep -iE "error|warning" || true

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb wave.tcl
	rm -rf verify/xsim.dir verify/*.log verify/*.jou verify/*.pb verify/*.wdb
	rm -rf log
	mkdir -p log