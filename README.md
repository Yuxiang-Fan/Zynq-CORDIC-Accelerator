# CORDIC Hardware Accelerator Implementation on Zynq-7000 SoC

This project implements a hardware acceleration modules for the Coordinate Rotation Digital Computer (CORDIC) algorithm on the **Xilinx Zynq-7000 SoC** platform using **Vivado 2018.3**. The design utilizes a PS-PL heterogeneous architecture to perform trigonometric and inverse trigonometric calculations through iterative logic.

## Implementation Characteristics

* **16-Stage Pipelined Architecture**: The core logic is designed with a 16-level pipeline to support data throughput during sequential processing.
* **Q16.16 Fixed-Point Representation**: A 32-bit fixed-point strategy is employed to manage hardware resource utilization while maintaining computational precision.
* **Function Support**: The implementation provides support for sine, cosine, arcsine, and arctangent functions by switching between rotation and vectoring iteration modes.
* **Data Interaction**: The **AXI Uartlite** IP core is integrated for data communication between the Processor System (PS) and Programmable Logic (PL).

## Validation and Performance

The implementation has been verified on the Zybo Z7-10 development board with the following experimental observations:

* **Computational Accuracy**: Measured values exhibit an error margin of less than **0.05%** relative to theoretical benchmarks.
* **Synchronization**: A Finite State Machine (FSM) is implemented to coordinate data transmission and maintain synchronization between modules.
