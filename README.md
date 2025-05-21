# AI Accelerator Project

![Project Status](https://img.shields.io/badge/status-active--development-orange.svg) 
![HDL](https://img.shields.io/badge/HDL-SystemVerilog-blue.svg)

A high-performance AI accelerator implementation with multi-core processing and optimized memory subsystem.

## 🚀 Features

### Implemented
- **Multi-Core Architecture**
  - 4 parallel processing cores (configurable)
  - Pipelined MAC (Multiply-Accumulate) units
  - ReLU activation function implementation
- **Memory System**
  - Dual-port RAM with write-through behavior
  - Bank arbitration logic
  - Separate weight/data memory spaces
- **Simulation**
  - Memory subsystem testbench
  - Basic DMA control verification

### Work in Progress
- Full DMA engine implementation
- Weight/bias loading system
- Pipeline hazard handling
- Quantization-aware processing

## 📂 Project Structure
```
AI_Accelerator/
├── Makefile # Build automation
├── rtl/ # RTL source code
│ ├── AI_Accelerator.sv # Top-level accelerator
│ ├── AI_Core.sv # Processing core implementation
│ ├── Memory_Subsystem.sv # Memory controller + DMA
│ ├── Arithmetic_Units.sv # MAC units and math ops
│ ├── weight_mem.sv # Weight storage memory
│ └── ram/ # Memory components
│ └── behav_dual_port_ram.sv
├── tb/ # Verification components
│ ├── Memory_Subsystem_tb.sv # Memory subsystem tests
│ ├── test # Test scripts
│ └── test.sv # Main test suite
├── docs/ # Documentation
├── images/ # Diagrams
└── scripts/ # Tooling scripts
```

## 💻 Getting Started

### Simulation (Using Verilator/ModelSim)
Run memory subsystem tests
verilator --binary -j 0 -Wall --top-module Memory_Subsystem_tb tb/Memory_Subsystem_tb.sv rtl/Memory_Subsystem.sv rtl/ram/behav_dual_port_ram.sv
./obj_dir/VMemory_Subsystem_tb


### Key Parameters
AI_Accelerator #(
.DATA_WIDTH(32), // 32-bit data path
.ADDR_WIDTH(16), // 64KB address space
.NUM_CORES(4) // Scalable core count
) accelerator (...);

## 🛠️ Roadmap

- [ ] Complete DMA engine implementation
- [ ] Add weight loading sequence
- [ ] Implement pipeline forwarding
- [ ] Add fixed-point quantization support
- [ ] Develop full system testbench

## 🤝 Contributing

This project welcomes contributions! Please see:
1. Open an issue for feature requests/bugs
2. Fork the repository
3. Create a feature branch
4. Submit a pull request

## 📜 License
[MIT License](LICENSE) - See [LICENSE.md](LICENSE) for details

---
