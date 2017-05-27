

module mips_pipeline(

	input	clk,
	input rst
);




reg halt;

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

wire [31:0] dado_lido_1; //ligado ao IR[25:21]
wire [31:0] dado_lido_2; //ligado ao IR[20:16]

// write enable: o valor é 1 quando for pra escrever nos registradores
// por causa da existencia desse trem, nao precisa fazer nada no estagio 5
wire signal_br_in_w_en;

// valor do registrador de destino
wire [5:0] signal_rd;


	mem_inst mem_i(
	
	.address(PC),
	.clock(clk),
	.q(out_mem_inst)
	);
	

	banco_de_registradores br(

	.br_in_clk(clk),
	.br_in_rst(rst),
	.br_in_rs(IR_1[25:21]),
	.br_in_rt(IR_1[20:16]),
	.br_in_rd(signal_rd),
	.br_in_data(saida_ula_2),
	.br_in_w_en(signal_br_in_w_en),
	.br_out_R_rs(dado_lido_1),
	.br_out_R_rt(dado_lido_2)
	);


// se for uma operacao do tipo R, o segundo registrador passado é o de destino
// se nao (tipo I), é o segundo
assign signal_rd	=	(IR_4[31:26] == 6'b000000) ? IR_4[15:11] : IR_4[20:16];

// para as instrucoes add, sub, addi e load, sempre que elas estiverem no
// ultimo estagio, o write enable vai ser 1. caso contrario, ele e zero,
// o resto do trabalho pra escrever ja e feito no banco de regs.
assign signal_br_in_w_en = ((IR_4[31:26] == 6'b000000 && (IR_4[5:0] == 6'b100000 || IR_4[5:0] == 6'b100010)) || IR_4[31:26] == 6'b001000 || IR_4[31:26] == 6'b100011)  ? 1'b1 : 1'b0;
	
// nosso loop de execucao (FICA TUDO NO MESMO POSEDGE MESMO)
	always@(posedge clk)begin
	
		if(rst == 1'b1)
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
				////////////////////////////
				//leitura do banco de registradores / decode
				////////////////////////////
				
				
				
				
				
				
				
				////////////////////////////
				//Excute
				////////////////////////////
				if(IR_2[31:26] == 6'b000000)begin
					if(IR_2[5:0] == 6'b100000)begin
						saida_ula_1 <= A + B_1;
					end
				end
				
				B_2 <= B_1;
				IR_3 <= IR_2;
				////////////////////////////
				//Excute
				////////////////////////////
				
				
				
				
				
				
				
				
				////////////////////////////
				//Memory
				////////////////////////////
				saida_ula_2 <= saida_ula_1;
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
