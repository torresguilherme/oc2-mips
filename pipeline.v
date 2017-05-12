

module pipeline(

	input		clk,
	input		rst,
	output[7:0]		out_valor1,
	output[7:0]		out_valor2,
	output[7:0]		out_valor3
);

wire[4:0] signal_rd;

reg[31:0] ir1;
reg[31:0] ir2;
reg[31:0] ir3;
reg[31:0] ir4;

reg[31:0] a;
reg[31:0] b;
reg[31:0] c;
reg[31:0] d;

banco_de_registradores br(
	.br_in_SW(SW[4:0]),
	.br_out_reg_para_a_placa(signal_reg_para_a_placa),
	.br_in_clk(clk[25]),
	.br_in_rs(ir1[25:21]),
	.br_in_rt(ir1[20:16]),
	.br_in_rd(signal_rd),
	.br_in_data(d),
	.br_out_R_rs(a),
	.br_out_R_rt(b)
);// // instanciando o banco de registardores

reg[7:0] PC;

wire [7:0] out_rom;

reg halt;

	rom rom_1 (.address(PC),.clock(clk),.q(out_rom));
	
		
	assign out_valor1 = ir1;
	assign out_valor2 = ir2;
	assign out_valor3 = ir3;
	
	
	// primeiro estagio
	always@(posedge clk)begin
	
		if(rst == 1'b1)
		begin
			ir1 <= 8'b0;
			PC <= 8'b0;
			halt <= 1'b1;
		end
		
		else
		begin
			
			if(halt == 1'b1)
			begin
				halt <= 1'b0;
				PC <= PC + 1;
			end
			
			else
			begin
				PC <= PC + 1;
				ir1 <= out_rom;
			end
		end
		
	end

	// segundo estagio
	always@(posedge clk)begin
	
		if(rst == 1'b1)
		begin
			ir2 <= 8'b0;
		end
		
		else
		begin
			if(ir1[31:26 == 6'b000000]) // instrucao tipo R
			begin
				// pega os valores de a e b no banco de registradores
			end

			else if(ir1[31:26] == 6'b)
		end
	end
	
	// terceiro estagio - execucao
	always@(posedge clk)begin
	
		if(rst == 1'b1)
		begin
			ir3 <= 8'b0;
		end
		
		else
		begin
			
			ir3 <= ir2;
		end
		
	end

	// quarto estagio - memoria
	always@(posedge clk)begin
		sif(rst == 1'b1)
		begin
			ir4 <= 8b'0;
		end

		else
		begin

			ir4 <= ir3;
		end

	end

	// quinto estagio - write back
	always@(posedge clk)begin

	end
	
	
endmodule
