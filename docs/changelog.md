# PR 7

* minor changes to the structure of directories. all modules were changed to correctly import tb_pkg. driver was adjusted to be split between reset and main phase. added uvm_testname variable to make… …file.
* removal of useless comments
* once again, more useless comments removed
* monitor implemented & instantiated in env. begginings of scoreboard implementation.
* required includes added, config class created and implemented, makefile adjusted to have verbosities listed.
* Merge branch 'master' into dev-improveduvm
* scoreboard created and implemented, instantiated in env, attached into pkg and enabled in test.
* Merge branch 'dev-improveduvm' of [https://github.com/siwiaszczykb/sv.uvm.verification-labs](https://github.com/siwiaszczykb/sv.uvm.verification-labs) into dev-improveduvm
* gitignore updated to remove .vscode settings directory from repo
* Delete .vscode directory
* in the meantime I have decided to unify naming conventions - all relevant modules now begin with i2c (not only some). coverage has been implemented and instantated.
* Merge branch 'dev-improveduvm' of [https://github.com/siwiaszczykb/sv.uvm.verification-labs](https://github.com/siwiaszczykb/sv.uvm.verification-labs) into dev-improveduvm
* merge conflicts fixed. no idea why they existed in the first place :(
* git ignore fix attempt, magic numbers fixed
* magic numbers fix

# PR 6

* minor changes to the structure of directories. all modules were changed to correctly import tb_pkg. driver was adjusted to be split between reset and main phase. added uvm_testname variable to make…
* removal of useless comments
* once again, more useless comments removed
* monitor implemented & instantiated in env. begginings of scoreboard implementation.
* required includes added, config class created and implemented, makefile adjusted to have verbosities listed.
* Merge branch 'master' into dev-improveduvm

# PR 5

* minor changes to the structure of directories. all modules were changed to correctly import tb_pkg. driver was adjusted to be split between reset and main phase. added uvm_testname variable to make…
* removal of useless comments
* once again, more useless comments removed

# PR 4

* new branch for developing a uvm based environment created, makefile modified to accomodate different tests
* an attempt to create a logical structure of uvm files needed in the future
* sequence item implementation's attempt
* sequence_item & basic sequence implementation attempt; uvm_driver implementation beginnings
* driver implementation?
* final commit for today I guess, basic sequencer definition
* uvm env implementation
* slight dir adjustment, uvm_test implementation
* multiple bug fixes: sequence adjustments, driver flush before item.done. tests likely work properly at the moment, as per waveforms.

# PR 3

* new branch created for purposes of implementing a more advanced basic verification & uvm support. package file created to implement an enum for commands.
* attempting to implement a enum+values' correctness, however I've implemented new errors for now destroying the controller by accident
* slight changes in controller fixed the issue. task 1 implemented.
* makefile enriched with code coverage raport generation capability. gitignore modified to ignore coverage raport's dir.
* testbench modified to include data&addr randomization
* uvm library attached, SV logging prints changes to its UVM counterpart. makefile adjusted appropriately, added verbosity argument.

# PR 2

* first commit - working makefile, gitignore, basic tb implementation
* Made sure everything works: adjusted makefile, new signals added to TB, incl. basic assertions
* +actual module to test
* I've gone back a few commits to remove my I2C memory and have switched to the suggested SPI memory model. hopefully repo will survive
* the suggested module was I2C, not SPI, but compared to mine contains read ID logic, so I'll leave it. added basic port definitions, a planned structure of FSM.
* attempts on building a read_id-ready controller
* rolling back to the controller I had previously built, with some changes to it. working read ID logic.
* working controller implementation for all four expected functionalities: read id; status; read&write any data. modified makefile - waveform generation when wave flag = 1 added
* Merge branch 'master' into dev-controller

# PR 1

* first commit - working makefile, gitignore, basic tb implementation
* Made sure everything works: adjusted makefile, new signals added to TB, incl. basic assertions
* +actual module to test