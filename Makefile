# Directories
RTL_DIR = rtl
RAM_DIR = $(RTL_DIR)/ram
TB_DIR = tb

# Source files
SOURCES = $(wildcard $(RTL_DIR)/*.sv) \
          $(wildcard $(RAM_DIR)/*.sv) \
          $(wildcard $(TB_DIR)/*.sv)

# Compiler flags
IVERILOG = iverilog
IVERILOG_FLAGS = -g2012 -y $(RTL_DIR) -y $(RAM_DIR)

# Targets
simv: $(SOURCES)
    $(IVERILOG) $(IVERILOG_FLAGS) -o $@ $(TB_DIR)/Memory_Subsystem_tb.sv

run: simv
    vvp simv -lxt2
    gtkwave dump.vcd

clean:
    rm -f simv dump.vcd

.PHONY: run clean
