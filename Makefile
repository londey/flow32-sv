
SRCS := $(wildcard src/*.sv)
TEST_BENCHES := $(wildcard test/testbench/*.sv)

TOP = Top


all:
	@make clean
	@make synth
	@make place
	@make pack
	@make uf2

# @make verilator

srcs:
	@echo $(SRCS)


synth: $(SRCS)
	@echo $(SRCS)
	@mkdir -p build
	@yosys -p 'synth_ice40 -abc9 -top $(TOP) -json build/design.json' $(SRCS)


place: build/design.json
	@rm -f build/design.asc
	@nextpnr-ice40 --Werror --package sg48 --up5k --freq 48 --top Top --json build/design.json --pcf src/pinmap.pcf --asc build/design.asc


pack: build/design.asc
	@rm -f build/design.bin
	@icepack build/design.asc build/design.bin


uf2: build/design.bin
	@rm -f build/design.uf2
	@bin2uf2 -o build/design.uf2 build/design.bin


verilator: $(SRCS)
	@echo $(SRCS)
	@rm -rf build/verilator
	@mkdir -p build/verilator/obj
	verilator --sc --exe --top-module Top --Mdir build/verilator/obj -Wall test/verilator/verilator_main.cpp $(SRCS)  
	@make -j -C build/verilator/obj -j -f VTop.mk VTop
	./build/verilator/VTop

# make -j -C obj_dir -f Vour.mk Vour


clean:
	@rm -rf build/*


build/test/%.vvp: test/%.sv
	@mkdir -p build/test
	@iverilog -o $@ $<

.PHONY: test
test: $(TESTS)
	for test in $(TESTS); do \
		build/$${test%.sv}.vvp; \
	done
