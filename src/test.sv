module test(
    input a, b,
    output logic c
);
    initial begin
        $display("Hello, World! asdf");
    end

    always_comb begin
        c = 0;
        if (a)
            c = b;
    end

endmodule
