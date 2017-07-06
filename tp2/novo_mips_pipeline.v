

module novo_mips_pipeline(

	input				CLOCK_50,// Para a placa
	input[3:0]		KEY, // Para a placa
	input[17:0]		SW, // Para a placa
	output[8:0]		LEDG, // Para a placa
	output[0:6]		HEX0, // Para a placa
	output[0:6]		HEX1, // Para a placa
	output[0:6]		HEX2, // Para a placa
	output[0:6]		HEX3, // Para a placa
	output[0:6]		HEX4, // Para a placa
	output[0:6]		HEX5, // Para a placa
	output[0:6]		HEX6, // Para a placa
	output[0:6]		HEX7 // Para a placa

);




reg halt;


reg [31:0] clk; // contador utilizado para deixar a frequência do clock na placa mais lento

//PC -> enderecos no arquivo vao de zero a 1023, entao tem 10 bits
reg [9:0] PC;

// registradores intermediarios no pipeline
reg [31:0] IR_1;
reg [31:0] IR_2;
reg [31:0] IR_3;
reg [31:0] IR_4;

//guarda a saida da ULA 
reg [31:0] saida_ula_1; //para ser usada no quarto estagio
reg [31:0] saida_ula_2; //para ser usada no quinto estagio

//primeiro operando rs
reg [31:0] A;

//segundo operando rt
reg [31:0] B_1;
reg [31:0] B_2; //rt encaminhado para o quarto estagio (necessario para o store)

wire [31:0] out_mem_inst; //saida da memoria de instrucao (o IR_1 recebe esse valor)
wire [31:0] out_mem_data; //saida da memoria de dados


wire [31:0] dado_lido_1; //ligado ao IR[25:21]
wire [31:0] dado_lido_2; //ligado ao IR[20:16]

// write enable: o valor é 1 quando for pra escrever nos registradores
// por causa da existencia desse trem, nao precisa fazer nada no estagio 5
wire signal_br_in_w_en;
wire signal_wren;

// valor do registrador de destino
wire [4:0] signal_rd;



	mem_inst mem_i(
	
	.address(PC),
	.clock(clk[25]),
	.q(out_mem_inst)
	);
	
	
	
	//MEM DATA
	
	mem_data mem_d(
	
	.address(saida_ula_1[9:0]), 
	.clock(clk[25]),
	.data(B_2), 
	.wren(signal_wren),
	.q(out_mem_data));
	
	
	

	banco_de_registradores br(

	.br_in_clk(clk[25]),
	.br_in_rst(KEY[0]),
	.br_in_rs(IR_1[25:21]),
	.br_in_rt(IR_1[20:16]),
	.br_in_rd(signal_rd),
	.br_in_data(saida_ula_2),
	.br_in_w_en(signal_br_in_w_en),
	.br_out_R_rs(dado_lido_1),
	.br_out_R_rt(dado_lido_2)
	);
	
	
	
	//////////DECODER////////////
	
	displayDecoder DP7_0(
	.entrada(saida_ula_1[3:0]),
	.saida(HEX0)); // para a placa
	
	displayDecoder DP7_1(
	.entrada(saida_ula_2[7:4]),
	.saida(HEX1)); // para a placa
	
	assign LEDG[0] = clk[25];
	
	
	
	always@(posedge clk[25])begin
		clk = clk + 1;
	end
	
	//////////DECODER////////////
	
	
	
assign signal_wren	=	(IR_3[31:26] == 6'b101011) ? 1 : 0; //data mem

// se for uma operacao do tipo R, o segundo registrador passado é o de destino
// se nao (tipo I), é o segundo
assign signal_rd	=	(IR_4[31:26] == 6'b000000) ? IR_4[15:11] : IR_4[20:16];

// para as instrucoes add, sub, addi e load, sempre que elas estiverem no
// ultimo estagio, o write enable vai ser 1. caso contrario, ele e zero,
// o resto do trabalho pra escrever ja e feito no banco de regs.
assign signal_br_in_w_en = ((IR_4[31:26] == 6'b000000 && (IR_4[5:0] == 6'b100000 || IR_4[5:0] == 6'b100010)) || IR_4[31:26] == 6'b001000 || IR_4[31:26] == 6'b100011)  ? 1'b1 : 1'b0;
	
// nosso loop de execucao (FICA TUDO NO MESMO POSEDGE MESMO)
	always@(posedge clk[25])begin
	
		if(KEY[0] == 1'b0)
		begin
			
			PC <= 10'b0;
			IR_1 <= 32'b0;
			IR_2 <= 32'b0;
			IR_3 <= 32'b0;
			IR_4 <= 32'b0;
			A <= 32'b0;
			B_1 <= 32'b0;
			B_2 <= 32'b0;
			saida_ula_1 <= 32'b0;
			saida_ula_2 <= 32'b0;
				
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
				IR_1 <= out_mem_inst;

		
		
				
				
				////////////////////////////
				//leitura do banco de registradores / decode
				////////////////////////////
				A <= dado_lido_1;
				B_1 <= dado_lido_2;
				IR_2 <= IR_1;
				
				// INSTRUCAO NOP
		
//		if(IR_1[31:0] != 32'b0)
//		begin
//		
//		if(IR_1[31:26] == 6'b000000 || IR_1[31:26] == 6'b000100)begin
//
//		if(
//		IR_1[25:21] == IR_2[25:21] || IR_1[25:21] == IR_3[25:21] ||
//      IR_1[20:16] == IR_2[20:16] || IR_1[20:16] == IR_3[20:16] ||
//		IR_1[25:21] == IR_4[25:21] ||
//      IR_1[20:16] == IR_4[20:16]
//		) begin
//				
//				IR_2[31:0] <= 32'b0;
//				PC <= PC;
//			end
//			
//		end
//		
//		
//		
//		if(IR_1[31:26] == 6'b001000 || IR_1[31:26] == 6'b100011 )begin
//		
//		if(
//		IR_1[25:21] == IR_2[25:21] || IR_1[25:21] == IR_3[25:21] ||
//		IR_1[25:21] == IR_4[25:21]
//		) begin
//				
//				IR_2[31:0] <= 32'b0;
//				PC <= PC;
//			end
//			
//		end
//		
//		end
		
		
				////////////////////////////
				//leitura do banco de registradores / decode
				////////////////////////////
				
				
				
				
				
				
				
				////////////////////////////
				//Excute
				////////////////////////////
				if(IR_2[31:26] == 6'b000000)begin
					if(IR_2[5:0] == 6'b100000)begin //add
						saida_ula_1 <= A + B_1;
					end
					if(IR_2[5:0] == 6'b100010)begin //sub
						saida_ula_1 <= A - B_1;
					end
				end
				
				if(IR_2[31:26] == 6'b001000)begin //addi
				
					saida_ula_1 <= A + {{16{IR_2[15]}}, IR_2[15:0]};
					
				end
				
				if(IR_2[31:26] == 6'b000100)begin //beq
				
					//saida_ula_1 <= A + B_1;
					if(A == B_1)
					begin
					
					PC <= PC + {{16{IR_2[15]}}, IR_2[15:0]};
					
					end
					
				end
				
				if(IR_2[31:26] == 6'b000010)begin //jump
				
				PC[9:0] <= IR_2[9:0];
					
				end
				
				if(IR_2[31:26] == 6'b100011)begin //lw
				
					saida_ula_1 <= A + {{16{IR_2[15]}}, IR_2[15:0]};
					
				end
				
				if(IR_2[31:26] == 6'b101011)begin //sw
				
					saida_ula_1 <= A + {{16{IR_2[15]}}, IR_2[15:0]};
					
				end
				
				B_2 <= B_1; //para SW
				IR_3 <= IR_2;
				////////////////////////////
				//Excute
				////////////////////////////
				
				
				
				
				
				
				
				
				////////////////////////////
				//Memory
				////////////////////////////
				saida_ula_2 <= saida_ula_1;
				//if(IR_3[31:26] == 6'b100011)begin //lw
				
					//saida_ula_2 <= out_mem_data;
					
				//end
				IR_4 <= IR_3;
				////////////////////////////
				//Memory
				////////////////////////////
				
				
				
				
				
				
				////////////////////////////
				//WB
				////////////////////////////
				
				////////////////////////////
				//WB
				////////////////////////////
				
			end
		end
		
	end
	
	

endmodule
