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

---

# 基于 Zynq-7000 SoC 的 CORDIC 硬件加速器实现

本项目在 **Xilinx Zynq-7000 SoC** 平台上（使用 **Vivado 2018.3**）实现了一个用于坐标旋转数字计算（CORDIC）算法的硬件加速模块。该设计利用 PS-PL 异构架构，通过迭代逻辑进行三角函数和反三角函数计算。

## 实现特性

* **16 级流水线架构**：核心逻辑采用 16 级流水线设计，以支持顺序处理期间的高数据吞吐量。
* **Q16.16 定点数表示**：采用 32 位定点化策略，在保持计算精度的同时优化硬件资源利用率。
* **功能支持**：通过在旋转（Rotation）模式和向量（Vectoring）模式之间切换，支持正弦、余弦、反正弦和反正切函数。
* **数据交互**：集成了 **AXI Uartlite** IP 核，用于处理器系统（PS）与可编程逻辑（PL）之间的数据通信。

## 验证与性能

该实现在 Zybo Z7-10 开发板上进行了验证，实验观察结果如下：

* **计算精度**：实测值与理论基准相比，误差范围小于 **0.05%**。
* **同步机制**：实现了一个有限状态机（FSM）来协调数据传输，并保持模块间的同步。
