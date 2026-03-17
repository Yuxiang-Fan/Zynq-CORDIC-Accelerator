# Zynq-CORDIC-Accelerator

This project implements a high-performance CORDIC (Coordinate Rotation Digital Computer) hardware accelerator on the **Xilinx Zynq-7000 SoC** platform using **Vivado 2018.3**. It utilizes a PS-PL heterogeneous architecture to perform complex trigonometric calculations with high efficiency and precision.

## Key Features

* **16-Stage Pipeline Architecture**: Designed with a 16-level pipeline to maximize data throughput and enable real-time processing.
* **Q16.16 Fixed-Point Strategy**: Employs a 32-bit fixed-point representation to balance hardware resource utilization and computational accuracy.
* **Multi-Function Support**: Capable of calculating sin, cos, arcsin, and arctan functions through specialized iteration modes.
* **Resource-Efficient Interaction**: Uses the **AXI Uartlite** IP core for lightweight communication between PS and PL.

## Performance and Validation

The design has been validated on-board (Zybo Z7-10) with the following results:

* **Precision**: All calculated values maintain an error margin of less than **0.05%** compared to theoretical values.
* **Stability**: The custom FSM synchronization mechanism ensures robust data transmission.

---

**Yuxiang Fan (Yuxiang-Fan)** Undergraduate @ Tongji University  
Focusing on **Embodied AI** 