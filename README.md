# Ethernet-Transmitter-Tx-
# Ethernet 10GEMAC RTL Design – Transmitter (Tx) Path

This project focuses on the **RTL design and verification of the Transmitter (Tx) path** of a 10-Gigabit Ethernet Media Access Controller (10GEMAC) using **Verilog HDL**. The goal is to implement key transmit-side logic aligned with Ethernet 802.3ae standards and verify its correctness through simulation.

## 🛠️ Tools Used
- **HDL**: Verilog
- **Simulation Tool**: Questa SIM (ModelSim)

## 🚀 Project Highlights

- ✅ Designed the **Transmitter (Tx) module** of a 10G Ethernet MAC core.
- ⚙️ Implemented:
  - **Frame assembly** logic
  - **CRC-32 checksum** generation
  - **Preamble insertion** and **inter-frame gap (IFG)** logic
- 🔄 Developed a **Finite State Machine (FSM)** to control data transmission based on MAC status and valid input conditions.
- 🧪 Created **testbenches** to verify timing, signal integrity, and frame formatting.
- 🔍 Simulated and debugged the Tx path to ensure correctness in:
  - Frame boundaries
  - Timing alignment
  - CRC accuracy
- 📚 Gained hands-on understanding of:
  - 10G Ethernet MAC protocol
  - Frame structures
  - Transmission behavior and inter-packet timing

## 📂 Directory Structure

10GEMAC-Tx/
├── src/ # RTL source files (Verilog)
├── tb/ # Testbenches and simulation files
├── waveforms/ # Captured waveform images or .do files
├── docs/ # Design specs or supporting documentation
└── README.md # Project overview and usage instructions


## ✅ How to Run Simulation

1. Open Questa SIM.
2. Compile the RTL and testbench files.
3. Run simulation using `vsim` or GUI mode.
4. Use waveform viewer to verify output and CRC.


## 📌 Future Scope

- Extend design to include Receiver (Rx) path.
- Integrate full 10GEMAC core with configurable parameters.
- Perform synthesis and timing analysis in FPGA tools like Vivado.
