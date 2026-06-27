# UVM enviroment for verification of Microchip's 24CSM01 1M-BIT I2C SERIAL EEPROM

# How to interact with Makefile?

Available arguments:
|Argument name| Purpose| Input format | Default value
|--|--|--|--|
| WAVE | If turned on, waveforms are generated and displayed via Vivado's GUI | 1 = on; 0 = off | 0 |
|COV|If turned on, Vivado collect a coverage report| 1 = on; 0 = off | 0 |
|VERB|If changed, sets UVM prints verbosity for the entire environment| According to UVM's docs - UVM_NONE till UVM_DEBUG; OR int 0-500 | UVM_MEDIUM
|TEST|If changed, sets the currently used test | Valid UVM test name | i2c_test

# How to execute?

**Most common case** just *make* - it executes compilation, elaboration and runs simulation with default values. 

If needed, add the above listed arguments after the *make* command for additional features.

While the *make* all consists of *clean* as well, if needed *clean* can be executed separately for clearing of trash files and directories.
 
# What rules it consists of? What do they do?
**all:** does it all (clean init comp_rtl comp_tb elab run report)

**init:** creates log & cov dirs 

**comp_rtl:** executes xvlog for rtl.f filelist

**comp_tb:** executes xvlog for verif.f filelist

**elab:** executes xelab

**run:** runs the simulation and/or GUI for waveforms

**report:** runs xcrg to collect coverage from Vivado

**clean:** removes trash files & log and cov dirs

