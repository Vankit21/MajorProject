module KB_data_binary_conv(data_kb,binary_data);

input [7:0] data_kb;
output reg [3:0] binary_data;

always @(data_kb)
begin
	if(data_kb == 8'h45)
		binary_data = 4'b0000;
	else if(data_kb == 8'h16)
		binary_data = 4'b0001;
	else if(data_kb == 8'h1E)
		binary_data = 4'b0010;
	else if(data_kb == 8'h26)
		binary_data = 4'b0011;
	else if(data_kb == 8'h25)
		binary_data = 4'b0100;
	else if(data_kb == 8'h2E)
		binary_data = 4'b0101;
	else if(data_kb == 8'h36)
		binary_data = 4'b0110;
	else if(data_kb == 8'h3D)
		binary_data = 4'b0111;
	else if(data_kb == 8'h3E)
		binary_data = 4'b1000;
	else if(data_kb == 8'h46)
		binary_data = 4'b1001;
	else if(data_kb == 8'h79)
		binary_data = 4'b1010;
	else if(data_kb == 8'h7B)
		binary_data = 4'b1011;
	else 
		binary_data = 4'b0000;
end
endmodule


