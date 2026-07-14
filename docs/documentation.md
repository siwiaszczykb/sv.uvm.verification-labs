# Design & Testbench Architecture

## 1. Verification Intent

This project verifies a custom I2C Controller RTL against the M24CSM01 EEPROM simulation model. The main goal is to test standard memory read/write operations, multi-byte burst transfers, and the hardware busy-polling mechanism. The environment also verifies how the system handles timing violations using error injection.

## 2. Design Behaviour (DUT)

The DUT translates parallel commands into the serial I2C protocol.

* **FSM:** The core logic is a 9-state Finite State Machine (IDLE, GEN_START, TX_BYTE, WAIT_ACK, etc.) that controls the SDA and SCL lines.
* **Burst Mode:** The controller features a 128-bit `w_data_reg`. It can transmit up to 16 bytes in a single write operation without resending the device address, using an internal byte counter.

## 3. Testbench Dataflow

The testbench is built according to UVM guidelines.

* **`i2c_seq_item`:** Contains randomized variables (`addr`, `cmd`, `w_data`). It uses a constraint (`c_w_data_mask`) to zero out unused upper bytes depending on the chosen burst length.
* **Driver & Monitor:** The `i2c_driver` executes the handshake with the DUT (`valid` and `ready` signals) via the virtual interface, while the `i2c_monitor` passively samples the bus and broadcasts completed transactions.
* **Scoreboard:** Uses an associative array (`logic [7:0] memory [logic[16:0]]`) as a reference model. During burst writes, it slices the 128-bit bus into single bytes and stores them. During reads, it compares the received data against this memory.
* **Coverage:** Collects functional coverage for used commands and memory address ranges.

## 4. Test Scenarios

Tests are automated using a Python script (`run.py`) and a `Makefile`.

* **Random Test (`i2c_test`):** Uses `i2c_random_seq` to generate a random mix of single and burst operations.
* **Long Read Test:** Writes 16 bytes in a single burst, then reads them back byte-by-byte to check memory alignment.
* **Polling Test:** Verifies the busy-polling capability. The scoreboard is temporarily disabled (`cfg.scoreboard_enable = 0`) to ignore the dummy `0xFF` reads while the EEPROM is busy writing.
* **Error Injection Test:** Intentionally violates the EEPROM's 5.5ms write cycle timing by reading immediately after a write. The regression script is configured to expect this `UVM_ERROR` to pass the test.