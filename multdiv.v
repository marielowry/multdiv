module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] divResult, multResult;
    wire multException, divException, multReady, divReady, multTrue, divTrue;
    
    // tff tff_div(divTrue, (ctrl_DIV || divReady), clock, ctrl_MULT);
    // tff tff_select(multTrue, (ctrl_MULT || multReady), clock, ctrl_DIV);
    // tff tff_div(divTrue, ctrl_DIV || ctrl_MULT, clock, data_resultRDY);
    // tff tff_select(multTrue, ctrl_MULT, clock, divTrue);


    //dffe_ref (q, d, clk, en, clr);
    dffe_ref multTrue_dff(multTrue, ctrl_MULT, clock, ctrl_MULT, ctrl_DIV);

    // one register for calculating, reset to zero when finished


    multiplier doMult(data_operandA, data_operandB, clock, multResult, multException, multReady, ctrl_MULT);
    divider doDiv(data_operandA, data_operandB, clock, divResult, divException, divReady, ctrl_DIV);

    assign data_result = multTrue ? multResult : divResult;
    assign data_exception = multTrue ? multException : divException;
    assign data_resultRDY = multTrue ? multReady : divReady;

    // assign data_result = ~divTrue ? multResult : divResult;
    // assign data_exception = ~divTrue ? multException : divException;
    // assign data_resultRDY = ~divTrue ? multReady : divReady;


    // assign data_result = multTrue ? multResult : (divTrue ? divResult : 32'b1);
    // assign data_exception = multTrue ? multException : (divTrue ? divException : 32'b1);
    // assign data_resultRDY = multTrue ? multReady : (divTrue ? divReady : 32'b1);


    // assign data_result = multResult;
    // assign data_exception = multException;
    // assign data_resultRDY = multReady;

endmodule