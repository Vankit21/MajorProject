module seven_segment_decoder(binary_data,seg);
input [3:0] binary_data;
output reg [6:0] seg;
wire [3:0]res;

always@(binary_data)
    begin
        case (binary_data) 
            4'h0 : seg = 7'b1000000;
            4'h1 : seg = 7'b1111001;
            4'h2 : seg = 7'b0100100;
            4'h3 : seg = 7'b0110000;
            4'h4 : seg = 7'b0011001;
            4'h5 : seg = 7'b0010010;
            4'h6 : seg = 7'b0000010;
            4'h7 : seg = 7'b1111000;
            4'h8 : seg = 7'b0000000;
            4'h9 : seg = 7'b0010000;
				4'hA : seg = 7'h39;
				4'hB : seg = 7'h3F;
            default : seg = 7'h06; 
        endcase
	 end
	 
endmodule
	

    
/*assign res = (data_kb == 8'h45)? 4'h0:
				 (data_kb == 8'h16)? 4'h1:
				 (data_kb == 8'h1E)? 4'h2:
				 (data_kb == 8'h26)? 4'h3:
				 (data_kb == 8'h25)? 4'h4:
				 (data_kb == 8'h2E)? 4'h5:
				 (data_kb == 8'h36)? 4'h6:
				 (data_kb == 8'h3D)? 4'h7:
				 (data_kb == 8'h3E)? 4'h8:
				 (data_kb == 8'h46)? 4'h9:
				 (data_kb == 8'h79)? 4'hA:
				 (data_kb == 8'h7B)? 4'hB:4'hC; */