RTL_LOG = log/rtl.log
VERIFY_LOG = log/verify.log
ELAB_LOG = log/elab.log

all: rtl verify elab

rtl:
	xvlog -sv -f rtl/rtl.f 2>&1 | tee -a $(RTL_LOG) | grep -iE "error|warning" || true

verify:
	xvlog -sv -f verify/verif.f 2>&1 | tee -a $(VERIFY_LOG) | grep -iE "error|warning" || true

elab:
	xelab -top top_tb -snapshot top_tb_snap 2>&1 | tee -a $(ELAB_LOG) | grep -iE "error|warning" || true

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb

#zmienic formatowanie na ok albo not ok