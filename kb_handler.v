module kb_handler(kb_clk,kb_data,rstn,clk_50,data_out,trigger);
input kb_clk,kb_data;
input clk_50,rstn;
output reg [7:0]data_out;
output trigger;

reg [2:0] clk_delayed;
wire kb_clk_delayed,kb_clk_delayed1;
reg [32:0]shift_reg;
reg [5:0]count;
wire rstn_mod;

always @(posedge clk_50)
	clk_delayed <= {clk_delayed[1:0],kb_clk};

assign kb_clk_delayed = clk_delayed[1];

always @(posedge kb_clk_delayed, negedge rstn_mod) 
	begin
		if (!rstn_mod)
			shift_reg <= 33'd0;
		else
			shift_reg <= {kb_data,shift_reg[32:1]};
	end
	
assign kb_clk_delayed1 = clk_delayed[2];	

assign rstn_mod = (rstn == 1'b0 || count == 6'd33)? 1'b0:1'b1;

always @(posedge kb_clk_delayed1, negedge rstn_mod) 
begin
	if (!rstn_mod)
		count <= 6'd0;
	else
		count <= count + 6'd1;
end

always @(posedge kb_clk_delayed1, negedge rstn) begin
	if (!rstn)
		data_out <= 6'd0;
	else
		if (count == 6'd31)
		data_out <= shift_reg[9:2];
	end
	
assign trigger = (count == 6'd32)?1'b1:1'b0;

endmodule

	
