
# **RISC-V Pipelined Processor with Vector Extension (Verilog Implementation)**<br><br>

This project presents the design and simulation of a pipelined RISC-V processor with a custom vector extension implemented using Verilog HDL. The processor follows a modular RTL design approach and demonstrates how scalar and vector instructions can be integrated within a pipelined architecture to support parallel computation.<br><br>

The scalar core is based on a RISC-V architecture and implements a pipelined datapath including instruction fetch, instruction decode, execute, memory, and write-back stages. Pipeline registers are used between stages to improve instruction throughput and allow multiple instructions to be processed simultaneously.<br><br>

To enhance computational performance for data-parallel workloads, a vector execution unit is integrated into the processor. The vector unit operates on wide vector registers and performs SIMD-style operations, enabling multiple data elements to be processed within a single instruction. The vector architecture includes a vector register file, vector ALU, vector instruction decoding logic, and pipeline control for vector operations.<br><br>

The processor supports vector arithmetic operations such as vector addition and vector subtraction, operating on 128-bit vector registers composed of multiple 32-bit elements. Vector operands are read from the vector register file and passed through the execution pipeline where the vector ALU performs element-wise computations.<br><br>

To ensure correct pipeline operation, a hazard detection unit is implemented. The hazard unit identifies dependencies between instructions and generates stall signals when required. This prevents incorrect data propagation through the pipeline and ensures proper execution order when vector instructions interact with other instructions in the pipeline.<br><br>

Simulation and verification of the processor were performed using a Verilog testbench environment. Waveform analysis was used to validate instruction flow, vector operand propagation, ALU execution, and pipeline control signals such as stall and hazard indicators. Test programs were written to verify the correct execution of vector instructions and confirm the functionality of the vector register file and execution unit.<br><br>

This project demonstrates key concepts in computer architecture and digital design, including pipelined processor design, SIMD vector computation, hazard detection mechanisms, and RTL implementation using Verilog. The design provides a foundation for further extensions such as additional vector instructions, vector memory operations, SIMD multiplication units, and FPGA implementation.<br><br>

The project is intended for educational and research purposes to explore processor architecture, hardware acceleration, and vector computing using the open RISC-V instruction set architecture.
