

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
reg[31:0] dado_lido1;
reg[31:0] dado_lido2;

banco_de_registradores br(
	.br_in_SW(SW[4:0]),
	.br_out_reg_para_a_placa(signal_reg_para_a_placa),
	.br_in_clk(clk[25]),
	.br_in_rs(ir1[25:21]),
	.br_in_rt(ir1[20:16]),
	.br_in_rd(signal_rd),
	.br_in_data(d),
	.br_out_R_rs(dado_lido1),
	.br_out_R_rt(dado_lido2)
);// // instanciando o banco de registardores

reg[7:0] PC;

wire [7:0] out_rom;

reg halt;

	//rom rom_1 (.address(PC),.clock(clk),.q(out_rom)); <--- Apenas exemplo do monitor?
	mem_inst mem_i(.address(PC),.clock(clk[25]),.q(out_mem_inst));
	mem_data mem_d(.address(saida_ula[9:0]), .clock(clk[25]), .data(B), .wren(signal_wren), .q(out_mem_data));
	displayDecoder DP7_0(.entrada(signal_reg_para_a_placa[3:0]),.saida(HEX0)); // para a placa
	displayDecoder DP7_1(.entrada(signal_reg_para_a_placa[7:4]),.saida(HEX1)); // para a placa


	assign out_valor1 = ir1;
	assign out_valor2 = ir2;
	assign out_valor3 = ir3;


	// primeiro estagio - fetch
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

	// segundo estagio - decodificaçao
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
					if(ir1[5:0] == 6'b1000000)
					begin
						//FSM2 = 8'b00000001;//add
					end
					else if(ir1[5:0] == 6'b100010)
					begin
						//FSM2 = 8'b00000011; //sub
					end
			end

			else if(ir1[31:26] == 6'b001000) // addi
			begin
				//pega o valor de a
				//+ imediato
				//FSM2 = 8'b00000010;//addi
			end

			else if(IR[31:26] == 6'b000010) //jump
			begin

			  //FSM2 = 8'b00000101;//j
			end

			else if(IR[31:26] == 6'b000100) //beq
			begin

				//FSM2 = 8'b00000100;//beq
			end

			else if(IR[31:26] == 6'b100011) //load
			begin
			 //FSM2 = 8'b00000110;//load
			end

			else if(IR[31:26] == 6'b101011) //store
			begin
			 //FSM2 = 8'b00000111;//store
			end

			A = dado_lido_1;
			B = dado_lido_2;
			immediate = {{16{IR[15]}}, IR[15:0]};

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

		 if(FSM2 == 8'b00000001)// execute add
		 begin
			saida_ula = A + B; //A,B e FSM2 em ir2?
		 end

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
