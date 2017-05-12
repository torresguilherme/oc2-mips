module banco_de_registradores(

	input					br_in_clk,
	input[4:0]			br_in_rs,
	input[4:0]			br_in_rt,
	input[4:0]			br_in_rd,
	input[31:0]			br_in_data,
	output reg[31:0]	br_out_R_rs,
	output reg[31:0]	br_out_R_rt,
	input[4:0] 			br_in_SW, // para a placa
	output reg[31:0]	br_out_reg_para_a_placa // para a placa
);



reg [31:0] zero;
reg [31:0] at;
reg [31:0] v0;
reg [31:0] v1;
reg [31:0] a0;
reg [31:0] a1;
reg [31:0] a2;
reg [31:0] a3;
reg [31:0] t0;
reg [31:0] t1;
reg [31:0] t2;
reg [31:0] t3;
reg [31:0] t4;
reg [31:0] t5;
reg [31:0] t6;
reg [31:0] t7;
reg [31:0] s0;
reg [31:0] s1;
reg [31:0] s2;
reg [31:0] s3;
reg [31:0] s4;
reg [31:0] s5;
reg [31:0] s6;
reg [31:0] s7;
reg [31:0] t8;
reg [31:0] t9;
reg [31:0] k0;
reg [31:0] k1;
reg [31:0] gp;
reg [31:0] sp;
reg [31:0] fp;
reg [31:0] ra;

always@(br_in_rs, br_in_rt, br_in_SW)begin
		
	case(br_in_rs[4:0])
		5'b00000:br_out_R_rs = zero;
		5'b00001:br_out_R_rs = at;
		5'b00010:br_out_R_rs = v0;
		5'b00011:br_out_R_rs = v1;
		5'b00100:br_out_R_rs = a0;
		5'b00101:br_out_R_rs = a1;
		5'b00110:br_out_R_rs = a2;
		5'b00111:br_out_R_rs = a3;
		5'b01000:br_out_R_rs = t0;
		5'b01001:br_out_R_rs = t1;
		5'b01010:br_out_R_rs = t2;
		5'b01011:br_out_R_rs = t3;
		5'b01100:br_out_R_rs = t4;
		5'b01101:br_out_R_rs = t5;
		5'b01110:br_out_R_rs = t6;
		5'b01111:br_out_R_rs = t7;
		5'b10000:br_out_R_rs = s0;
		5'b10001:br_out_R_rs = s1;
		5'b10010:br_out_R_rs = s2;
		5'b10011:br_out_R_rs = s3;
		5'b10100:br_out_R_rs = s4;
		5'b10101:br_out_R_rs = s5;
		5'b10110:br_out_R_rs = s6;
		5'b10111:br_out_R_rs = s7;
		5'b11000:br_out_R_rs = t8;
		5'b11001:br_out_R_rs = t9;
		5'b11010:br_out_R_rs = k0;
		5'b11011:br_out_R_rs = k1;
		5'b11100:br_out_R_rs = gp;
		5'b11101:br_out_R_rs = sp;
		5'b11110:br_out_R_rs = fp;
		5'b11111:br_out_R_rs = ra;
		default: br_out_R_rs = 32'b0;
	endcase
	
	case(br_in_rt[4:0])
		5'b00000:br_out_R_rt = zero;
		5'b00001:br_out_R_rt = at;
		5'b00010:br_out_R_rt = v0;
		5'b00011:br_out_R_rt = v1;
		5'b00100:br_out_R_rt = a0;
		5'b00101:br_out_R_rt = a1;
		5'b00110:br_out_R_rt = a2;
		5'b00111:br_out_R_rt = a3;
		5'b01000:br_out_R_rt = t0;
		5'b01001:br_out_R_rt = t1;
		5'b01010:br_out_R_rt = t2;
		5'b01011:br_out_R_rt = t3;
		5'b01100:br_out_R_rt = t4;
		5'b01101:br_out_R_rt = t5;
		5'b01110:br_out_R_rt = t6;
		5'b01111:br_out_R_rt = t7;
		5'b10000:br_out_R_rt = s0;
		5'b10001:br_out_R_rt = s1;
		5'b10010:br_out_R_rt = s2;
		5'b10011:br_out_R_rt = s3;
		5'b10100:br_out_R_rt = s4;
		5'b10101:br_out_R_rt = s5;
		5'b10110:br_out_R_rt = s6;
		5'b10111:br_out_R_rt = s7;
		5'b11000:br_out_R_rt = t8;
		5'b11001:br_out_R_rt = t9;
		5'b11010:br_out_R_rt = k0;
		5'b11011:br_out_R_rt = k1;
		5'b11100:br_out_R_rt = gp;
		5'b11101:br_out_R_rt = sp;
		5'b11110:br_out_R_rt = fp;
		5'b11111:br_out_R_rt = ra;
		default: br_out_R_rt = 32'b0;
	endcase
	
	// para a placa
	case(br_in_SW[4:0])
		5'b00000:br_out_reg_para_a_placa = zero;
		5'b00001:br_out_reg_para_a_placa = at;
		5'b00010:br_out_reg_para_a_placa = v0;
		5'b00011:br_out_reg_para_a_placa = v1;
		5'b00100:br_out_reg_para_a_placa = a0;
		5'b00101:br_out_reg_para_a_placa = a1;
		5'b00110:br_out_reg_para_a_placa = a2;
		5'b00111:br_out_reg_para_a_placa = a3;
		5'b01000:br_out_reg_para_a_placa = t0;
		5'b01001:br_out_reg_para_a_placa = t1;
		5'b01010:br_out_reg_para_a_placa = t2;
		5'b01011:br_out_reg_para_a_placa = t3;
		5'b01100:br_out_reg_para_a_placa = t4;
		5'b01101:br_out_reg_para_a_placa = t5;
		5'b01110:br_out_reg_para_a_placa = t6;
		5'b01111:br_out_reg_para_a_placa = t7;
		5'b10000:br_out_reg_para_a_placa = s0;
		5'b10001:br_out_reg_para_a_placa = s1;
		5'b10010:br_out_reg_para_a_placa = s2;
		5'b10011:br_out_reg_para_a_placa = s3;
		5'b10100:br_out_reg_para_a_placa = s4;
		5'b10101:br_out_reg_para_a_placa = s5;
		5'b10110:br_out_reg_para_a_placa = s6;
		5'b10111:br_out_reg_para_a_placa = s7;
		5'b11000:br_out_reg_para_a_placa = t8;
		5'b11001:br_out_reg_para_a_placa = t9;
		5'b11010:br_out_reg_para_a_placa = k0;
		5'b11011:br_out_reg_para_a_placa = k1;
		5'b11100:br_out_reg_para_a_placa = gp;
		5'b11101:br_out_reg_para_a_placa = sp;
		5'b11110:br_out_reg_para_a_placa = fp;
		5'b11111:br_out_reg_para_a_placa = ra;
		default: br_out_reg_para_a_placa = 32'b0;
	endcase
	
end
		
endmodule
	
