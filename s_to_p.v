`default_nettype none

module s_to_p #(
    parameter IWIDTH = 8,
    parameter OWIDTH = 8
) (
    input wire clk1,
	input wire clk2,
    input wire rst,

    input wire i_data,

    output reg [IWIDTH*OWIDTH-1:0] o_reg,
    input wire o_ready
);

reg [IWIDTH:0] i_ctr;
reg [OWIDTH:0] o_ctr;
reg [IWIDTH-1:0] i_reg;
reg [1:0] state;
parameter state_1 = 0, state_2 = 1;

always @(posedge clk or posedge rst) begin

    if (rst) 
		state = state_1;
    else begin
        case (state)
			state_1: /* Load i_reg*/
				if(i_ctr = IWIDTH)
					state = state_2;
			state_2: /* Load o_reg */
				state = state_1;
			default: state = state_1;
		endcase
    end
end

always @(posedge clk or posedge rst) begin

    if (rst) begin
        i_ctr   <= 0;
		o_ctr 	<= 0;
        i_reg 	<= 0;
        o_reg  <= 0;
    end else begin
	    case (state)
			state_1: /* Load i_reg with i_data until i_reg is full */
				if (i_cntr < IWIDTH) begin
                i_ctr <= i_ctr + 1;
                i_reg[i_ctr] <= i_data;
				end
			state_2: /* Load o_reg indexed by o_ctr */
				i_ctr <= 0;
				o_ctr <= o_ctr + 1;
				o_reg[(o_ctr * OWIDTH) + OWIDTH : 0] = i_reg;
		endcase
    end
end

endmodule

`default_nettype wire
