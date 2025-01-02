module test_tb;
    // verilator lint_off UNUSED
    logic a, b, c;
    // verilator lint_on UNUSED

    test dut(.*);
    initial begin
        a = 1;
        b = 1;
        #1;
        $finish;
    end
endmodule
