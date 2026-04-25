import tb_pkg::*;

class i2c_sequencer extends uvm_sequencer;
	`uvm_component_utils (i2c_sequencer)
	function new (string name="i2c_sequencer", uvm_component parent);
		super.new (name, parent);
	endfunction

endclass