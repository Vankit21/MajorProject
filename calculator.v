module calculator(key, out, clk, clk_k,rst,seg,led);

input clk,key,rst,clk_k;
output [3:0] out;
output reg [6:0] seg;
output reg[7:0]led;

reg[98:0] sr;
reg[2:0] clk_delayed;
wire clk_delay;

reg[32:0]first;
reg[65:33]operator;
reg[98:66]second;

wire [7:0] inp1;
wire[7:0] inp2;
wire[7:0]oper;

reg[3:0]f_in;
reg[3:0]s_in;
reg[3:0]res;
reg[3:0]display;
reg[2:0] PS,NS;
reg [6:0] count;

parameter idle = 3'd1, input1 = 3'd2, opr = 3'd3, input2 = 3'd4, operation = 3'd5, result = 3'd6; 

always@(posedge clk_k)
	begin
		clk_delayed <= {clk_delayed[1:0],clk};
	end
		
	assign clk_delay = clk_delayed[2];
	
always@(negedge clk_delay, negedge rst)
	begin 
		if(!rst)
				sr <= 99'b0;
		else 	
				sr = {key,sr[98:1]};
	end
		
always@(posedge clk, negedge rst)                                      
	begin 
		if (!rst)
			count <= 7'd98;
		else
		//	if (PS == operation || PS == idle)
		//		count <= 7'd98;
		//	else
				count <= count - 7'd1;	   	
	end	

always@(posedge clk_k, negedge rst)	
	begin
		if (!rst)
			led <= 8'd0;
		else
			if(count == 7'd0)
				led <= sr[8:1];
			else
				if(count == 7'd33)
				led <= sr[41:34];
			else
				if(count == 7'd66)
					led <= sr[74:67];
	end
			
	
always@(posedge clk_k,negedge rst)
	begin
		if(!rst)
			PS <= idle;
		else
			PS <= NS;
	end

always@(PS,count,oper,res)
	begin
		case(PS)
			
			idle :
				begin
					if(count == 7'd32)
						NS <= input1;
					else 
						NS <= idle;
				end
				
			input1 :
				begin
					if(count == 7'd65)
						NS <= opr;
					else
						NS <= input1;
				end
				
			opr :
				begin
					if (count == 7'd98)
						NS <= input2;
					else
						NS <= opr;
				end
						
			input2 : 
				begin
					if (oper == 8'h79 || oper == 8'h7B || oper == 8'h7C || oper == 8'h4A)
						NS <= operation;
					else
						NS <= input2;
				end
					
			default :
				begin
					if(res > 4'b0000 && res <= 4'b1010)
						NS <= idle;
					else
						NS <= operation; 
				end
		endcase
	end
			
			
always@(posedge clk_k, negedge rst)
	begin
		if(!rst)
			begin
				first <= 33'b0;
			end
		else 
			if (count == 7'd32)
				first <= sr[32:0];
			else
				first <= first;
	end

assign inp1 = first[30:23];

always@(posedge clk_k, negedge rst)
	begin
		if(!rst)
			f_in <= 4'b0000;
		else 	
			if(inp1 == 8'h45)
				f_in <= 4'b0000;
			else 	
				if(inp1 == 8'h16)
					f_in <= 4'b0001;
				 else
					 if( inp1 == 8'h1E)
						 f_in <= 4'b0010;
					 else
						 if( inp1 == 8'h26)
							 f_in <= 4'b0011;
						 else
							 if( inp1 == 8'h25)
								 f_in <= 4'b0100;
							 else
								 if( inp1 == 8'h2E)
									 f_in <= 4'b0101;
								 else
									 if( inp1 == 8'h36)
										 f_in <= 4'b0110;
									 else
										 if( inp1 == 8'h3D)
											 f_in <= 4'b0111;
										 else
											 if( inp1 == 8'h3E)
												 f_in <= 4'b1000;
											 else
												 if( inp1 == 8'h46)
													 f_in <= 4'b1001;
												 else 
													 f_in <= 4'b0000;	 
											  end
											  
always@(posedge clk_k, negedge rst)
	begin
		if(!rst)
			begin
				operator <= 33'b0;
			end
		else 
			if (count == 7'd65)
				operator <= sr[65:33];
			else
				operator <= operator;
	end

assign oper = operator[63:56];
	
always@(posedge clk_k, negedge rst)
	begin
		if(!rst)
			res <= 4'b0000;
		else	
			if(oper == 8'h79)
				res <= f_in + s_in;
				else
					if(oper == 8'h7B)
						res <= f_in - s_in;
					else
						if(oper == 8'h7C)
							res <= f_in * s_in;
						else
							if(oper == 8'h4A)
								res <= f_in / s_in;
							else 
								res <= 4'b0000;
							end
							
always@(posedge clk_k, negedge rst)
	begin
		if(!rst)
			begin
				second <= 33'b0;
			end
		else
			if ( count == 7'd98)
				second <= sr[97:66];
			else
				second <= second;
	end
	
assign inp2 = second[96:89];
	
always@(posedge clk_k, negedge rst)  
	begin
		if(!rst)
			s_in <= 4'b0000;
		else 	
			if(inp2 == 8'h45)
				s_in <= 4'b0000;
			else 	
				if(inp2 == 8'h16)
					s_in <= 4'b0001;
				 else
					 if( inp2 == 8'h1E)
						 s_in <= 4'b0010;
					 else
						 if( inp2 == 8'h26)
							 s_in <= 4'b0011;
						 else
							 if( inp2 == 8'h25)
								 s_in <= 4'b0100;
							 else
								 if( inp2 == 8'h2E)
									 s_in <= 4'b0101;
								 else
									 if( inp2 == 8'h36)
										 s_in <= 4'b0110;
									 else
										 if( inp2 == 8'h3D)
											 s_in <= 4'b0111;
										 else
											 if( inp2 == 8'h3E)
												 s_in <= 4'b1000;
											 else
												 if( inp2 == 8'h46)
													 s_in <= 4'b1001;
												 else 
													 s_in <= 4'b0000;	 
												  end				


 always@(res)
    begin
        case (res) 
            0 : seg = 7'b1000000;
            1 : seg = 7'b1111001;
            2 : seg = 7'b0100100;
            3 : seg = 7'b0110000;
            4 : seg = 7'b0011001;
            5 : seg = 7'b0010010;
            6 : seg = 7'b0000010;
            7 : seg = 7'b1111000;
            8 : seg = 7'b0000000;
            9 : seg = 7'b0010000;
				10 : seg = 7'b0011100; 
            default : seg = 7'b1111111; 
        endcase
	 end
					
assign out = (PS == res)? res:4'b0;

endmodule	
			









//idle : 
//				begin
//					if(count == 7'd0)
//						NS <= input1;
//					else 
//						NS <= idle;
//				end







//module calculator(key, out, clk, clk_k,rst,seg,LED_1);
//
//input clk,key,rst,clk_k;
//output [3:0] out;
//output reg [6:0] seg;
//output [7:0]LED_1;
//
//reg[98:0] sr1;
//reg[2:0] clk_delayed;
//wire clk_delay;
//wire [7:0] inp1;
//wire[7:0] inp2;
//wire[7:0] op;
//reg[3:0]f_in;
//reg[3:0]s_in;
//reg[7:0]oper;
//reg[3:0]res;
//reg[3:0]display;
//reg[7:0] PS,NS;
//reg [6:0] count;
//
//parameter idle = 3'd1, input1 = 3'd2, opr = 3'd3, input2 = 3'd4, result = 3'd5, last = 3'd6; 
//
//always@(posedge clk_k)
//	begin
//		clk_delayed <= {clk_delayed[1:0],clk};
//	end
//		
//	assign clk_delay = clk_delayed[2];
//	
//always@(negedge clk_delay, negedge rst)
//	begin 
//		if(!rst)
//				sr1 <= 99'b0;
//		else 	
//				sr1 = {key,sr1[98:1]};
//	end
//		
//always@(posedge clk, negedge rst)                                      
//	begin 
//		if (!rst)
//			count <= 7'd0;
//		else
//			if (PS == input1)
//				count <= 7'd0;
//			else
//				count = count + 7'd1;	   	
//	end		
//	
// assign op = sr1[30:23];
// assign inp2 = sr1[63:56];
// assign inp1 = sr1[96:89];
// assign LED_1 = sr1[96:89];
// 
//always@(posedge clk_k,negedge rst)
//	begin
//		if(!rst)
//			PS<= idle; 
//		else
//			PS<= NS; 
//   end			
//			
//always@(PS,count,f_in,s_in,oper,res,op)
//	begin
//		case(PS) 
//			
//			idle : 
//				begin
//					if(count == 7'd98)
//						NS<= input1;
//					else
//						NS<= idle;
//				end
//			
//			input1 :
//				begin
//					if(f_in > 4'b0000 && f_in <= 4'b1001) 
//						begin
//						NS <= opr;
//				      end
//					else
//				      begin
//						NS <= input1;
//	               end
//				end
//				
//			opr: 
//				begin 
//					if(op == 8'h79)
//						begin	
//						NS <= input2;
//						end 
//						else
//							if(op == 8'h7B)
//								begin
//								NS <= input2;
//							   end
//							else
//								if(op == 8'h7C)
//									begin
//									NS <= input2;
//									end
//									
//								else
//									if(op == 8'h4A)
//										begin
//										NS <= input2;
//										end
//              	else 
//						begin
//					   	NS <= opr;
//						end
//				 end		
//			
//			input2 : 
//				begin
//					if(s_in > 4'b0000 && s_in < 4'b1001)
//						begin
//						NS <= result;
//						end
//					else
//						begin
//						NS <= input2;
//						end
//			   end
//			
//			result :
//				begin
//			      if(oper == 8'h79 || oper == 8'h7B || oper == 8'h7C || oper == 8'h4A )
//						begin
//							NS <= last;
//					   end
//				   else
//						begin
//						NS <= result;	
//						end
//				end
//				
//			default : 
//				begin
//					if(res > 4'b0000 && res < 4'b1001)
//						NS <= idle;
//					else 
//						NS <= res;
//				end
//									
//		endcase
//	end
//			
//always@(posedge clk_k, negedge rst)
//	begin
//		if(!rst)
//			f_in <= 4'b0000;
//		else 	
//			if(inp1 == 8'h45)
//				f_in <= 4'b0000;
//			else 	
//				if(inp1 == 8'h16)
//					f_in <= 4'b0001;
//				 else
//					 if( inp1 == 8'h1E)
//						 f_in <= 4'b0010;
//					 else
//						 if( inp1 == 8'h26)
//							 f_in <= 4'b0011;
//						 else
//							 if( inp1 == 8'h25)
//								 f_in <= 4'b0100;
//							 else
//								 if( inp1 == 8'h2E)
//									 f_in <= 4'b0101;
//								 else
//									 if( inp1 == 8'h36)
//										 f_in <= 4'b0110;
//									 else
//										 if( inp1 == 8'h3D)
//											 f_in <= 4'b0111;
//										 else
//											 if( inp1 == 8'h3E)
//												 f_in <= 4'b1000;
//											 else
//												 if( inp1 == 8'h46)
//													 f_in <= 4'b1001;
//												 else 
//													 f_in <= 4'b0000;	 
//												  end
//
//always@(posedge clk_k, negedge rst)  
//	begin
//		if(!rst)
//			s_in <= 4'b0000;
//		else 	
//			if(inp2 == 8'h45)
//				s_in <= 4'b0000;
//			else 	
//				if(inp2 == 8'h16)
//					s_in <= 4'b0001;
//				 else
//					 if( inp2 == 8'h1E)
//						 s_in <= 4'b0010;
//					 else
//						 if( inp2 == 8'h26)
//							 s_in <= 4'b0011;
//						 else
//							 if( inp2 == 8'h25)
//								 s_in <= 4'b0100;
//							 else
//								 if( inp2 == 8'h2E)
//									 s_in <= 4'b0101;
//								 else
//									 if( inp2 == 8'h36)
//										 s_in <= 4'b0110;
//									 else
//										 if( inp2 == 8'h3D)
//											 s_in <= 4'b0111;
//										 else
//											 if( inp2 == 8'h3E)
//												 s_in <= 4'b1000;
//											 else
//												 if( inp2 == 8'h46)
//													 s_in <= 4'b1001;
//												 else 
//													 s_in <= 4'b0000;	 
//												  end	
//							
//always@(posedge clk_k, negedge rst)
//	begin
//		if(!rst)
//			res <= 4'b0000;
//		else	
//			if(oper == 8'h79)
//				res <= f_in + s_in;
//				else
//					if(oper == 8'h7B)
//						res <= f_in - s_in;
//					else
//						if(oper == 8'h7C)
//							res <= f_in * s_in;
//						else
//							if(oper == 8'h4A)
//								res <= f_in / s_in;
//							else 
//								res <= 4'b0000;
//							end
//
//always@(posedge clk_k)
//	begin
//		if(!rst)
//			display <= 4'b0000;
//			if(f_in > 4'b0000 && f_in <= 4'b1001)
//				begin
//				display <= f_in;
//				end
//				else
//					if(op == 8'h79)
//						begin
//						oper <= 8'h79;
//						display <= 4'b1010;
//						end
//					else
//						if(op == 8'h7B)
//							begin
//							oper <= 8'h7B;
//							display <= 4'b1010;
//							end
//						else
//							if(op == 8'h7B)
//								begin
//								oper <= 8'h7B;
//								display <= 4'b1010;
//								end
//							else
//								if(op == 8'h7B)
//									begin
//									oper <= 8'h7B;
//									display <= 4'b1010;
//									end
//								else
//									if(s_in > 4'b0000 && s_in < 4'b1001)
//										begin
//										display <= s_in;
//										end
//									else
//										if(oper == 8'h79 || oper == 8'h7B || oper == 8'h7C || oper == 8'h4A )
//											begin
//											display <= res;
//											end
//										else
//											begin
//											display <= 4'b0000;
//											end
//								end
//					
//
//always@(display)
//    begin
//        case (display) 
//            0 : seg = 7'b1000000;
//            1 : seg = 7'b1111001;
//            2 : seg = 7'b0100100;
//            3 : seg = 7'b0110000;
//            4 : seg = 7'b0011001;
//            5 : seg = 7'b0010010;
//            6 : seg = 7'b0000010;
//            7 : seg = 7'b1111000;
//            8 : seg = 7'b0000000;
//            9 : seg = 7'b0010000;
//				10 : seg = 7'b0011100; 
//            default : seg = 7'b1111111; 
//        endcase
//	 end
//	
//			
//	
//assign out = (PS == res)? res:4'b0;
//
//endmodule
//


                      
//module calculator(key, out, clk, clk_k,rst,seg,LED_1);
//
//input clk,key,rst,clk_k;
//output [3:0] out;
//output reg [6:0] seg;
//output [7:0]LED_1;
//
//reg[98:0] sr1;
//reg[2:0] clk_delayed;
//wire clk_delay;
//wire [7:0] inp1;
//wire[7:0] inp2;
//wire[7:0] op;
//reg[3:0]f_in;
//reg[3:0]s_in;
//reg[7:0]oper;
//reg[3:0]res;
//reg[3:0]display;
//reg[7:0] PS,NS;
//reg [6:0] count;
//wire [7:0] temp;
//parameter idle = 3'd1, input1 = 3'd2, opr = 3'd3, input2 = 3'd4, result = 3'd5, last = 3'd6; 
//
//always@(posedge clk_k)
//	begin
//		clk_delayed <= {clk_delayed[1:0],clk};
//	end
//		
//	assign clk_delay = clk_delayed[2];
//	
//always@(negedge clk_delay, negedge rst)
//	begin 
//		if(!rst)
//				sr1 <= 99'b0;
//		else 	
//				sr1 = {sr1[97:0],key};
//	end
//	
//	
//always@(negedge clk_delay, negedge rst)
//	begin 
//		if (!rst)
//			count <= 7'd0;
//		else
//			if (PS == input1)
//				count <= 7'd0;
//			else
//				count = count + 7'd1;		
//	end	
//	
// assign inp1 = sr1[31:24];
// assign inp2 = sr1[64:57];  
// assign op = sr1[97:90];	
// assign temp = sr1[31:24] ;
// assign LED_1 = sr1[31:24] ;
// 
//always@(posedge clk_k,negedge rst)
//	begin
//		if(!rst)
//			PS<= idle; 
//		else
//			PS<= NS; 
//   end			
//			
//always@(PS,count,f_in,s_in,oper,res,op)
//	begin
//		case(PS) 
//			
//			idle : 
//				begin
//					if(count == 7'd98)
//						NS<= input1;
//					else
//						NS<= idle;
//				end
//			
//			input1 :
//				begin
//					if(f_in > 4'b0000 && f_in < 4'b1001) 
//						begin
//						NS <= opr;
//				      end
//					else
//				      begin
//						NS <= input1;
//	               end
//				end
//				
//			opr: 
//				begin 
//					if(op == 8'h79)
//						begin	
//						NS <= input2;
//						end 
//						else
//							if(op == 8'h7B)
//								begin
//								NS <= input2;
//							   end
//							else
//								if(op == 8'h7C)
//									begin
//									NS <= input2;
//									end
//									
//								else
//									if(op == 8'h4A)
//										begin
//										NS <= input2;
//										end
//              	else 
//						begin
//					   	NS <= opr;
//						end
//				 end		
//			
//			input2 : 
//				begin
//					if(s_in > 4'b0000 && s_in < 4'b1001)
//						begin
//						NS <= result;
//						end
//					else
//						begin
//						NS <= input2;
//						end
//			   end
//			
//			result :
//				begin
//			      if(oper == 8'h79 || oper == 8'h7B || oper == 8'h7C || oper == 8'h4A )
//						begin
//							NS <= last;
//					   end
//				   else
//						begin
//						NS <= result;	
//						end
//				end
//				
//			default : 
//				begin
//					if(res > 4'b0000 && res < 4'b1001)
//						NS <= idle;
//					else 
//						NS <= res;
//				end
//									
//		endcase
//	end
//			
//always@(posedge clk_k, negedge rst)
//	begin
//		if(!rst)
//			f_in <= 4'b0000;
//		else 	
//			if(temp == 8'h16)
//				f_in <= 4'b0001;
//			 else
//				 if( temp == 8'h1E)
//					 f_in <= 4'b0010;
//				 else
//					 if( temp == 8'h26)
//						 f_in <= 4'b0011;
//					 else
//						 if( temp == 8'h25)
//							 f_in <= 4'b0100;
//						 else
//							 if( temp == 8'h2E)
//								 f_in <= 4'b0101;
//							 else
//								 if( temp == 8'h36)
//									 f_in <= 4'b0110;
//								 else
//									 if( temp == 8'h3D)
//										 f_in <= 4'b0111;
//									 else
//										 if( temp == 8'h3E)
//											 f_in <= 4'b1000;
//										 else
//											 if( temp == 8'h46)
//												 f_in <= 4'b1001;
//											 else 
//												 f_in <= 4'b0000;	 
//											  end
//
//always@(posedge clk_k, negedge rst)  
//	begin
//		if(!rst)
//			s_in <= 4'b0000;
//		else 	
//			if(temp == 8'h16)
//				s_in <= 4'b0001;
//			 else
//				 if( temp == 8'h1E)
//					 s_in <= 4'b0010;
//				 else
//					 if( temp == 8'h26)
//						 s_in <= 4'b0011;
//					 else
//						 if( temp == 8'h25)
//							 s_in <= 4'b0100;
//						 else
//							 if( temp == 8'h2E)
//								 s_in <= 4'b0101;
//							 else
//								 if( temp == 8'h36)
//									 s_in <= 4'b0110;
//								 else
//									 if( temp == 8'h3D)
//										 s_in <= 4'b0111;
//									 else
//										 if( temp == 8'h3E)
//											 s_in <= 4'b1000;
//										 else
//											 if( temp == 8'h46)
//												 s_in <= 4'b1001;
//											 else 
//												 s_in <= 4'b0000;	 
//											  end	
//						
//always@(posedge clk_k, negedge rst)
//	begin
//		if(!rst)
//			res <= 4'b0000;
//		else	
//			if(oper == 8'h79)
//				res <= f_in + s_in;
//				else
//					if(oper == 8'h7B)
//						res <= f_in - s_in;
//					else
//						if(oper == 8'h7C)
//							res <= f_in * s_in;
//						else
//							if(oper == 8'h4A)
//								res <= f_in / s_in;
//							else 
//								res <= 4'b0000;
//							end
//
//always@(posedge clk_k)
//	begin
//		if(!rst)
//			display <= 4'b0000;
//		if(f_in > 4'b0000 && f_in < 4'b1001)
//			begin
//			display <= f_in;
//			end
//			else
//				if(op == 8'h79)
//					begin
//				   oper <= 8'h79;
//					display <= 4'b1010;
//					end
//				else
//					if(op == 8'h7B)
//						begin
//						oper <= 8'h7B;
//						display <= 4'b1010;
//						end
//					else
//						if(op == 8'h7B)
//							begin
//							oper <= 8'h7B;
//							display <= 4'b1010;
//							end
//						else
//							if(op == 8'h7B)
//								begin
//								oper <= 8'h7B;
//								display <= 4'b1010;
//								end
//							else
//								if(s_in > 4'b0000 && s_in < 4'b1001)
//									begin
//									display <= s_in;
//									end
//								else
//									if(oper == 8'h79 || oper == 8'h7B || oper == 8'h7C || oper == 8'h4A )
//										begin
//										display <= res;
//										end
//									else
//										begin
//								      display <= 4'b0000;
//										end
//							end
//					
//
//always@(display)
//    begin
//        case (display) 
//            0 : seg = 7'b0000001;
//            1 : seg = 7'b1001111;
//            2 : seg = 7'b0010010;
//            3 : seg = 7'b0000110;
//            4 : seg = 7'b1001100;
//            5 : seg = 7'b0100100;
//            6 : seg = 7'b0100000;
//            7 : seg = 7'b0001111;
//            8 : seg = 7'b0000000;
//            9 : seg = 7'b0000100;
//				10 : seg = 7'b0011100; 
//            default : seg = 7'b1111111; 
//        endcase
//	 end
//	
//			
//	
//assign out = (PS == res)? res:4'b0;
//
//endmodule


                    
