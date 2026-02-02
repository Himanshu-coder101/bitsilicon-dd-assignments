# ============================
# Verilator Makefile
# ============================

# Top module name
TOP = stopwatch_top

# Verilog sources
RTL_DIR = ../rtl
VERILOG_SRCS = \
	$(RTL_DIR)/stopwatch_top.v \
	$(RTL_DIR)/control_fsm.v \
	$(RTL_DIR)/seconds_counter.v \
	$(RTL_DIR)/minutes_counter.v

# C++ source
CPP_SRC = main.cpp

# Output directory
OBJ_DIR = obj_dir

# Verilator command
VERILATOR = verilator

# Default target
all: build run

# ----------------------------
# Build
# ----------------------------

build:
	$(VERILATOR) -Wall --cc $(VERILOG_SRCS) --exe $(CPP_SRC)
	make -C $(OBJ_DIR) -f V$(TOP).mk

# ----------------------------
# Run
# ----------------------------

run:
	./$(OBJ_DIR)/V$(TOP)

# ----------------------------
# Clean
# ----------------------------

clean:
	rm -rf $(OBJ_DIR)

# ----------------------------
# Help
# ----------------------------

help:
	@echo "Targets:"
	@echo "  make        - Build and run"
	@echo "  make build
