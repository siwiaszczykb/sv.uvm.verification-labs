class i2c_scoreboard extends uvm_scoreboard;

    `uvm_component_utils (i2c_scoreboard)

    function new (string name = "i2c_scoreboard", uvm_component parent = null);
      super.new (name, parent);
    endfunction

endclass