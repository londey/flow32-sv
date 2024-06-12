
SRCS := $(wildcard src/*.sv)
TEST_BENCHES := $(wildcard test/testbench/*.sv)

TOP = Top

all:
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
	@rm build/design.asc
	@nextpnr-ice40 --Werror --package sg48 --up5k --freq 48 --top Top --json build/design.json --pcf src/pinmap.pcf --asc build/design.asc
# @arachne-pnr -d 1k -P tq144:4k -p build/pinmap.pcf build/design.blif -o build/design.txt

pack: build/design.asc
	@rm build/design.bin
	@icepack build/design.asc build/design.bin

uf2: build/design.bin
	@rm build/design.uf2
	@bin2uf2 -o build/design.uf2 build/design.bin

verilator: $(SRCS)
	@mkdir -p build/verilator/obj
	@verilator --sc -Wall --Mdir build/verilator/obj --cc $(SRCS) --exe test/verilator/verilator_main.cpp
	@make -C build/verilator -j -f build/verilator/obj/VTop.mk VTop
	@./build/verilator/VTop

clean:
	@rm -f build/*
 
#  The  $(SRCS)  variable is a list of all the .vs files in the src directory. The  all  target is the default target that will be run when you type  make  in the terminal. It runs the  yosys  command to synthesize the design, then the  arachne-pnr  command to place and route the design, and finally the  icepack  command to generate the binary file. The  clean  target is used to remove all the files in the build directory. 
#  The  @  symbol at the beginning of each command suppresses the output of the command. 
#  The  $(SRCS)  variable is used to pass the list of .vs files to the  yosys  command.

build/test/%.vvp: test/%.sv
	@mkdir -p build/test
	@iverilog -o $@ $<

.PHONY: test
test: $(TESTS)
	for test in $(TESTS); do \
		build/$${test%.sv}.vvp; \
	done
