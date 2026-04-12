RTL_LOG = log/rtl.log
VERIFY_LOG = log/verify.log
ELAB_LOG = log/elab.log
SIM_LOG = log/sim.log

WAVE = 0

all: comp_rtl comp_tb elab run

comp_rtl:
	xvlog -sv -work rtl_lib -f rtl.f 2>&1 | tee -a $(RTL_LOG) | grep -iE "error|warning" || true

comp_tb:
	xvlog -sv -work tb_lib -f verif.f 2>&1 | tee -a $(VERIFY_LOG) | grep -iE "error|warning" || true

elab:
	xelab -top tb_lib.top -snapshot top_tb_snap -L rtl_lib -L tb_lib 2>&1 | tee -a $(ELAB_LOG) | grep -iE "error|warning" || true

run:
	xsim top_tb_snap -R | tee -a $(SIM_LOG) | grep -iE "error|warning" || true

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb
	rm -rf verify/xsim.dir verify/*.log verify/*.jou verify/*.pb verify/*.wdb
	rm -rf log
	mkdir -p log