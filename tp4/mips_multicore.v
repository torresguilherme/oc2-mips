

module mips_multicore(
	
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

	integer a;
	integer b;
	reg stall1; //stall processadores
	reg stall2;
	
	reg [1:0] cache_table1[255:0]; //cache table do cache1
	reg cache_valido1[255:0];

	reg [1:0] cache_table2[255:0]; //cache table do cache2
	reg cache_valido2[255:0];

	wire [31:0]data_c1; //saida das caches
	wire [31:0]data_c2;
	
	reg [31:0]data_p1; //entrada de dados pros processadores
	reg [31:0]data_p2;
	
	reg r_en1c; //controle leitura caches
	reg w_en1c;

	reg r_en2c; //controle saida caches
	reg w_en2c;

	wire r_en1; //controle leitura P1
	wire w_en1;

	wire r_en2; //controle leitura P2
	wire w_en2;

	wire[11:0] adress1; //saida endereco dos processadores
	wire[11:0] adress2;

	reg[11:0] end_prim; //entrada endereco da memoria principal

	wire[31:0]data1; //saida de dados dos processadores
	wire[31:0]data2;
	
	reg[31:0]data_1; //entrada de dado das caches
	reg[31:0]data_2;

	reg[9:0] end1; //entrada de endereco das caches
	reg[9:0] end2;

	reg ren_mem; //controle leitura/escrita da memoria principal
	reg wen_mem;

	wire[31:0] dado_mem; //entrada de dados da MP
	reg[31:0] data_men; //saida de dados da MP

	integer i;

	integer achou1; //se dado esta na cache ou nao
	integer achou2;

	integer prioridade; //controle acessa concorrente na memoria principal

	reg [2:0]FSM1; //controla estados de acesso cache/memoria principal do p1
	reg [2:0]FSM2; //controla estados de acesso cache/memoria principal do p2
	reg [2:0]FSMG ;//controla estados incialmente (inicializa achou1 e achou2 caso stall = 1)
	
	reg [31:0] clk; // contador utilizado para deixar a frequência do clock na placa mais lento

mips_multi1 P1(.stall(stall1),.clk(clk),.KEY(KEY[0]),
				 .saida_cache(data_p1),
				  .SW(SW[17:0]), 
             .address(adress1[11:0]),
				 .data(data1[31:0]),
				 .r_en(r_en1),
				 .w_en(w_en1));

mips_multi2 P2(.stall(stall2),.clk(clk),.KEY(KEY[0]),
				  .saida_cache(data_p2), 
				  .SW(SW[17:0]),
             .address(adress2[11:0]),
				 .data(data2[31:0]),
				 .r_en(r_en2),
				 .w_en(w_en2));

cache1 c1(		
		.address(end1),
		.clock(clk[25]),
		.data(data_1),
		.rden	(r_en1c),
		.wren(w_en1c),
		.q(data_c1)
	);
	

cache1 c2(		
		.address(end2),
		.clock(clk[25]),
		.data(data_2),
		.rden	(r_en2c),
		.wren(w_en2c),
		.q(data_c2)
	);
	

	
memoria_principal mp(		
		.address(end_prim),
		.clock(clk[25]),
		.data(data_men),
		.rden	(ren_mem),
		.wren(wen_mem),
		.q(dado_mem)
	);
	
	assign LEDG[0] = clk[25]; 
	
	always@(posedge CLOCK_50)begin
		clk = clk + 1;
	end



    always@(posedge clk[25]) begin
	 
	 if(KEY[0] == 0)
	 begin
	 
	 a = 0;
	 b = 0;
	 
	 stall1 = 0;
	 stall2 = 0;
	 
	 achou1 = 0;
	 achou2 = 0;
	 prioridade = 0;
	 i = 0;

	//data_c1 = 32'b0;
	//data_c2 = 32'b0;
	//data_p1 = 32'b0;
	//data_p2 = 32'b0;
	
	

	
	end_prim = 12'b0;
	
	//data1 = 32'b0;
	//data2 = 32'b0;
	
	
	end1 = 10'b0;
	end2 = 10'b0;
	
	ren_mem = 0;
	wen_mem = 0;
	
	//dado_mem = 32'b0;
	//data_men = 32'b0;

	FSM1 = 3'b000;
	FSM2 = 3'b000;
	FSMG = 3'b000;

	 
	 for(i = 0; i < 256; i = i + 1)
	 begin

	cache_table1[i] = 0;
	cache_valido1[i] = 0;
	
	cache_table2[i] = 0;
	cache_valido2[i] = 0;

	 end


	end //end rst
	
	if(w_en1 == 1 || r_en1 == 1)
	begin
	
	
	stall1 = 1;
	
	end
	
	
	if(w_en2 == 1 || r_en2 == 1)
	begin
	
	
	stall2 = 1;
	
	end
	 
	 



	if(stall1 == 1 || stall2 == 1)
	begin
	
	if (adress1[11:10] == cache_table1[adress1[9:2]] && cache_valido1[adress1[9:2]] == 1)
	begin
	
	achou1 = 1;
	FSMG = 3'b001;
	
	end
	
	if (adress2[11:10] == cache_table2[adress2[9:2]] && cache_valido2[adress1[9:2]] == 1)
	begin
	
	achou2 = 1;
	FSMG = 3'b001;
	
	end
	
	end

	if(FSMG == 3'b001)
	begin

	if (achou1 == 1 && achou2 == 1)
	begin 
	 
	if(w_en1 == 1)
	begin

	end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
	data_1 = data1;
	FSM1 = 3'b001;
	w_en1c = 1;
	r_en1c = 0;


	if(FSM1 == 3'b001)
	begin

	end_prim = adress1; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data1;
	FSM1 = 3'b010;
	end
	
	if(FSM1 == 3'b010)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//w_en1 = 0;
	end
	
	end //terminal w_en1
	
	if(r_en1 == 1)
	begin

	end1 = adress1[9:2] + adress1[1:0]; //le da cache1
	w_en1c = 0;
	r_en1c = 1;
	FSM1 = 3'b001;


	if(FSM1 == 3'b010)
	begin

	data_p1 = data_c1; //manda dado pro banco de registradores em P1
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//r_en1 = 0;
   end
	
	end //end r_en1
	 
	 
	 
	if(w_en2 == 1)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache2
	data_2 = data2;
	FSM2 = 3'b001;
	w_en2c = 1;
	r_en2c = 0;


	if(FSM2 == 3'b001)
	begin

	end_prim = adress2; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data2;
	FSM2 = 3'b010;
	end

	if(FSM2 == 3'b010)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//w_en2 = 0;
	end
	 
	end //end w_en2
	
	if(r_en2 == 1)
	begin
							
							
														//le da cache2
	end2 = adress2[9:2] + adress2[1:0];
	w_en2c = 0;
	r_en2c = 1;
	FSM2 = 3'b001;


	if(FSM2 == 3'b010)
	begin

	data_p2 = data_c2; //manda dado pro banco de registradores em P1
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//r_en2 = 0;
   end
	
	end //end r_en2
	
	end//end first condition
	 
	 
	 
	if (achou1 == 0 && achou2 == 1)
	begin
	 
	if(r_en1 == 1)
	begin

	end_prim = adress1;    //le da memoria principal
	ren_mem = r_en1;
	wen_mem = 0;
	FSM1 = 3'b001;

	if(FSM1 == 3'b001)
	begin

	data_1 = dado_mem;   //escreve na cache1
	end1 = adress1[9:2] + adress1[1:0];
	w_en1c = 1;
	r_en1c = 0;
	FSM1 = 3'b010;
	end

	if(FSM1 == 3'b010)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	cache_valido1[adress1[9:2]] = 1;
	FSM1 = 3'b011;

	end

	if(FSM1 == 3'b011)
	begin


	end1 = adress1[9:2] + adress1[1:0]; //manda ler da cache1
	w_en1c = 0;
	r_en1c = 1;
	FSM1 = 3'b100;

	end

	if(FSM1 == 3'b100)
	begin

	data_p1 = data_c1; //manda dado pro banco de registradores em P1
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//r_en1 = 0;

	end
	
	end //end r_en1
	
	if(w_en1 == 1)
	begin

	end_prim = adress1; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data1;
	FSM1 = 3'b001;

	if(FSM1 == 3'b001)
	begin

	end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
	data_1 = dado_mem;
	w_en1c = 1;
	r_en1c = 0;
	FSM1 = 3'b010;
	
	end
	
	if(FSM1 == 3'b010)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	cache_valido1[adress1[9:2]] = 1;
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//w_en1 = 0;
	end
		
	end //end w_en1
	
	if(w_en2 == 1)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache2
	data_2 = data2;
	FSM2 = 3'b001;
	w_en2c = 1;
	r_en2c = 0;


	if(FSM2 == 3'b001)
	begin

	end_prim = adress2; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data2;
	FSM2 = 3'b010;
	end
	
	if(FSM2 == 3'b010)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//w_en2 = 0;
	end
	
	end //end w_en2
	 
	if(r_en2 == 1)
	begin

	end2 = adress2[9:2] + adress2[1:0];
	w_en2c = 0;
	r_en2c = 1;
	FSM2 = 3'b001;


	if(FSM2 == 3'b010)
	begin

	data_p2 = data_c2; //manda dado pro banco de registradores em P1
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//r_en2 = 0;

	end
	
	end //end r_en2


   end //end second condition
	 
	 
	if (achou1 == 1 && achou2 == 0)
	begin
	 
	if(w_en1 == 1)
	
	begin

	end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
	data_1 = data1;
	FSM2 = 3'b001;
	w_en1c = 1;
	r_en1c = 0;


	if(FSM2 == 3'b001)
	begin

	end_prim = adress1; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data_c1;
	FSM2 = 3'b010;
	end
	
	if(FSM2 == 3'b010)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	FSM2 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//w_en1 = 0;
	end
	
	end //end w_en1
	 
	if(r_en1 == 1)
	begin

	end1 = adress1[9:2] + adress1[1:0]; //le da cache1
	w_en1c = 0;
	r_en1c = 1;
	FSM2 = 3'b001;


	if(FSM2 == 3'b001)
	begin

	data_p1 = data_c1; //manda dado pro banco de registradores em P1
	FSM2 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//r_en1 = 0;
	end
	
	end //end r_en1
	
	if(r_en2 == 1)
	begin

	end_prim = adress2; //le na memoria principal
	ren_mem = 1;
	wen_mem = 0;
	FSM2 = 3'b001;

	if(FSM2 == 3'b001)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
	data_2 = dado_mem;
	w_en2c = 1;
	r_en2c = 0;
	FSM2 = 3'b010;
	end
	
	if(FSM2 == 3'b010)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	cache_valido2[adress2[9:2]]  = 1;
	FSM2 = 3'b011;
	end
	
	
	if(FSM2 == 3'b011)
	begin
	
	end2 = adress2[9:2] + adress2[1:0]; //le da c2
	w_en2c = 0;
	r_en2c = 1;
	FSM2 = 3'b100;
	end


	if(FSM2 == 3'b100)
	begin

	data_p2 = data_c2; //manda dado pro banco de registradores em P2
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//r_en2 = 0;
	
	end

	end //end r_en2
 

	if(w_en2 == 1)
	begin

	end_prim = adress2; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data2;
	FSM2 = 3'b001;

	if(FSM2 == 3'b001)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
	data_2 = dado_mem;
	w_en2c = 1;
	r_en2c = 0;
	FSM2 = 3'b010;
	end
	
	if(FSM2 == 3'b010)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	cache_valido2[adress2[9:2]]  = 1;
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//w_en2 = 0;
	
	end



	end //end w_en2 



	end //end third condition

	if (achou1 == 0 && achou2 == 0)
	
	begin

	prioridade = 1;
	FSM1 = 3'b001;

	if(r_en1 == 1 && FSM1 == 3'b001)
	begin

	end_prim = adress1;    //le da memoria principal
	ren_mem = r_en1;
	wen_mem = 0;
	FSM1 = 3'b010;
	FSM2 = 3'b001; //permite o p2 acessar MP
	prioridade = 0;

	if(FSM1 == 3'b010)
	begin

	data_1 = dado_mem;   //escreve na cache1
	end1 = adress1[9:2] + adress1[1:0];
	w_en1c = 1;
	r_en1c = 0;
	FSM1 = 3'b011;
	
	end

	if(FSM1 == 3'b011)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	cache_valido1[adress1[9:2]] = 1;
	FSM1 = 3'b100;

	end

	if(FSM1 == 3'b100)
	begin


	end1 = adress1[9:2] + adress1[1:0]; //manda ler da cache1
	w_en1c = 0;
	r_en1c = 1;
	FSM1 = 3'b101;

	end

	if(FSM1 == 3'b101)
	begin

	data_p1 = data_c1; //manda dado pro banco de registradores em P1
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//r_en1 = 0;

	end

	end //end r_en1


	if(w_en1 == 1 && FSM1 == 3'b001)
	begin

	end_prim = adress1; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data1;
	FSM1 = 3'b010;
	FSM2 = 3'b001;
	prioridade = 0;

	if(FSM1 == 3'b010)
	begin

	end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
	data_1 = dado_mem;
	w_en1c = 1;
	r_en1c = 0;
	FSM1 = 3'b011;
	end
	
	if(FSM1 == 3'b011)
	begin

	cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
	cache_valido1[adress1[9:2]] = 1;
	FSM1 = 3'b000;
	stall1 = 0; //termina
	achou1 = 0;
	//w_en1 = 0;

	end


	end //end w_en1

	if(prioridade == 0 && FSM2 == 3'b001)
	begin

	if(r_en2 == 1)
	begin

	end_prim = adress1; //le da memoria principal
	ren_mem = 1;
	wen_mem = 0;
	FSM2 = 3'b010;

	if(FSM2 == 3'b010)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
	data_2 = dado_mem;
	w_en2c = 1;
	r_en2c = 0;
	FSM2 = 3'b011;
	end
	
	if(FSM2 == 3'b011)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	cache_valido2[adress2[9:2]] = 1;
	FSM2 = 3'b100;
	
	end
	
	
	
	if(FSM2 == 3'b100)
	begin
	
	end2 = adress2[9:2] + adress2[1:0]; //le da c2
	w_en2c = 0;
	r_en2c = 1;
	FSM2 = 3'b101;
	end


	if(FSM2 == 3'b101)
	begin

	data_p2 = data_c2; //manda dado pro banco de registradores em P2
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//r_en2 = 0;
	
	end
	

	end //end r_en2


	if(w_en2 == 1 && FSM2 == 3'b001)
	begin

	end_prim = adress2; //escreve na memoria principal
	ren_mem = 0;
	wen_mem = 1;
	data_men = data2;
	FSM2 = 3'b010;

	if(FSM2 == 3'b010)
	begin

	end2 = adress2[9:2] + adress2[1:0]; //escreve na cache2
	data_2 = dado_mem;
	w_en2c = 1;
	r_en2c = 0;
	FSM2 = 3'b011;
	end
	
	if(FSM2 == 3'b011)
	begin

	cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
	cache_valido2[adress2[9:2]] = 1;
	FSM2 = 3'b000;
	stall2 = 0; //termina
	achou2 = 0;
	//w_en2 = 0;
	end



	end //end w_en2
	
	end //end prioridade 0



	end //end last condition 


	end //end FSMG
	
	end //end clock
	


endmodule
