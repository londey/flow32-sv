
SRCS := $(wildcard src/*.sv)
TEST_BENCHES := $(wildcard test/testbench/*.sv)

TOP = Top


all:
	@make clean
	@make synth
	@make place
	@make pack
	@make uf2
	
#   @make verilator

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
	@mkdir -p build/verilator/obj
	@verilator --sc -Wall --Mdir build/verilator/obj --cc $(SRCS) --exe test/verilator/verilator_main.cpp
	@make -C build/verilator -j -f build/verilator/obj/VTop.mk VTop
	@./build/verilator/VTop


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
