set -ex

verilator -f verilator.f --binary src/*.sv test/verilator/*.sv --top test_tb

./obj_dir/Vtest_tb 
