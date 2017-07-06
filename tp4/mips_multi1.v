

module mips_multi1(

	input  stall,
	input [31:0] clk,
	input [3:0]  KEY,
	
	input saida_cache,
	input [17:0]SW,
	
	output [11:0]address,
	output [31:0]data,
	output r_en,
	output w_en

);

integer para;

reg [2:0] FSM; // controle do estado do MIPS
reg [7:0] FSM2; // controle das instruções do MIPS


reg [9:0] PC; // Contador de programa do MIPS
reg [31:0] IR; // Registrador de instrução do MIPS
reg [31:0] immediate; // Imediato da instrução

reg [31:0] saida_ula; // registrador de saída da ULA do MIPS
reg [31:0] A; // Registrador A do MIPS
reg [31:0] B; // Registrador B do MIPS

wire [31:0] out_mem_inst; //saída da memória de instruções
wire signal_wren;

wire [4:0] signal_rd; // utilizado para "criar" o multiplexador que seleciona o registrador de destino do MIPS
wire [31:0] signal_dado_a_ser_escrito; // utilizado para "criar" o multiplexador que seleciona qual dado será salvo no banco de registradores do MIPS
wire [31:0] dado_lido_1; // dado lido do banco de registardores
wire [31:0] dado_lido_2; // dado lido do banco de registardores

wire [31:0] signal_reg_para_a_placa; // para a placa




	mem_inst_1 mem_i(.address(PC),.clock(clk[25]),.q(out_mem_inst)); // instanciando a memória de instruções (ROM)

	banco_de_registradores br(.br_in_SW(SW[4:0]), .br_out_reg_para_a_placa(signal_reg_para_a_placa), .br_in_clk(clk[25]), .br_in_FSM(FSM), .br_in_FSM2(FSM2), .br_in_rs(IR[25:21]), .br_in_rt(IR[20:16]), .br_in_rd(signal_rd), .br_in_data(signal_dado_a_ser_escrito), .br_out_R_rs(dado_lido_1), .br_out_R_rt(dado_lido_2)); // // instanciando o banco de registardores

			
	displayDecoder DP7_0(.entrada(signal_reg_para_a_placa[3:0]),.saida(HEX0)); // para a placa
	displayDecoder DP7_1(.entrada(signal_reg_para_a_placa[7:4]),.saida(HEX1)); // para a placa


	// código que cria o multiplexador que seleciona o dado a ser ecrito no registrador de destino do MIPS
	assign signal_dado_a_ser_escrito	=	(FSM == 3'b110 && FSM2 == 8'b00000110) ? saida_cache : saida_ula;
 

	// código que cria o multiplexador que seleciona o registrador de destino do MIPS
	assign signal_rd	=	(FSM == 3'b110 && (FSM2 == 8'b00000110 || FSM2 == 8'b00000010)) ? IR[20:16] : IR[15:11];
	
	//assign signal_wren	=	(FSM == 3'b101 && FSM2 == 8'b00000111) ? 0 : 1;
	
	
	assign address	=	(FSM == 3'b101 && (FSM2 == 8'b00000110 || FSM2 == 8'b00000111)) ? saida_ula[11:0] : 0;
			assign data	=	(FSM == 3'b101 && FSM2 == 8'b00000111) ? IR[20:16] : 0;
			
			
		assign r_en	=	(FSM == 3'b100 && FSM2 == 8'b00000110) ? 1 : 0;
		assign w_en	=	(FSM == 3'b100 && FSM2 == 8'b00000111) ? 1 : 0;

	
	//utilizando o bit 25 do contador clk como clock principal do projeto
	always@(posedge clk[25])begin
	
		if(KEY[0] == 0) // se o botão KEY[0] da placa for acionado, FMS vai para o estado de Reset
		begin
			FSM = 3'b0;
		end
		
		else// se não estiver apertando o KEY[0]...
		begin
		
			if(FSM == 3'b000)// Reset
			begin
				PC = 10'b0;
				IR = 32'b0;
				saida_ula = 32'b0;
				A = 32'b0;
				B = 32'b0;
				FSM = 3'b001;
				para = 0;
			end
			
			else if(FSM == 3'b001)// Halt
			begin
				FSM = 3'b010;
			end
			else 
			
			
			if(FSM == 3'b010) //Fetch
			begin
			
				//if(FSM2 != 8'b00000101 && FSM2 != 8'b00000100)
				//begin
				PC = PC + 1;
				//end
				IR = out_mem_inst;
				FSM = 3'b011;
				FSM2 = 8'b0; 
			end
			
			
			else if(FSM == 3'b011) // Decode
			begin
				if(IR[31:26] == 6'b000000)// R Instruction
				begin
					if(IR[5:0] == 6'b100000)
					begin
						FSM2 = 8'b00000001;//add
					end
					else if(IR[5:0] == 6'b100010)
					begin
						FSM2 = 8'b00000011; //sub
					end
				
				end else
				if(IR[31:26] == 6'b001000) // addi
				begin
					FSM2 = 8'b00000010;//addi
					immediate = IR[15:0];
				end else
				if(IR[31:26] == 6'b000100) // beq
				begin
					FSM2 = 8'b00000100;//beq
				end else
				if(IR[31:26] == 6'b000010) // j
				begin
					
					FSM2 = 8'b00000101;//j
					immediate = IR[25:0];
					PC = immediate;
					FSM = 3'b010;
					
				end else
				if(IR[31:26] == 6'b100011) // load
				begin
					FSM2 = 8'b00000110;//load
				end else
				if(IR[31:26] == 6'b101011) // store
				begin
					FSM2 = 8'b00000111;//store
				end
				
				
				A = dado_lido_1;
				B = dado_lido_2;
				FSM = 3'b100;
			end
			
			
			else if(FSM == 3'b100) // Execute
			begin
				if(FSM2 == 8'b00000001)// execute add
				begin
					//write_back = 1;
					saida_ula = A + B;
				end else
				if(FSM2 == 8'b00000010) // execute addi
				begin
					saida_ula = A + immediate; 
				end else
				if(FSM2 == 8'b00000011) // execute sub
				begin
					saida_ula = A - B; 
				end else
				if(FSM2 == 8'b00000100) // execute beq
				begin
					if(A==B)
					begin
						PC = PC + immediate + 4;  //+ 1?
						FSM = 3'b010;
					end
				end else
			
				if(FSM2 == 8'b00000110)// execute load
				begin
					saida_ula = A + immediate;
					//r_en = 1;
					//w_en = 0;
					para = 1;
				end else
				if(FSM2 == 8'b00000111) // execute store
				begin
				//w_en = 1;
				//r_en = 0;
				para = 1;
				   saida_ula = A + immediate;
				end
				
				FSM = 3'b101;
			end
			
			
			
			else if(FSM == 3'b101) // Memory
			begin
			
				if(stall != 1 && para == 2)
				begin
				
				para = 0;
				
				end
			
				if(stall == 1)
				begin
				
				para = 2;
				
				end
				
			
				
				
			   if(para != 1)
				begin
				
				FSM = 3'b110;
				end
				
				if(FSM2 == 8'b00000111 && para != 1)
				begin
				FSM = 3'b010;
				end
				
				
				if(FSM2 == 8'b00000111 || FSM2 == 8'b00000110)
				begin
				
				 
				 
					if(FSM2 == 8'b00000110)
					begin
					end
					
					if(FSM2 == 8'b00000111)
					begin
					end
				
				end
				
				
				
	
				
			end
			
			
			else if(FSM == 3'b110) // Write Back
			begin
				FSM = 3'b010;
				
				
				
			end
			
			end
			
			end
			

	endmodule