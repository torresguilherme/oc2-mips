

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


wire stall1;
wire stall2;
reg [1:0] cache_table1[255:0];
reg cache_valido1[255:0];

reg [1:0] cache_table2[255:0];
reg cache_valido2[255:0];

reg data_c1[31:0];
reg data_c2[31:0];
reg data_p1[31:0];
reg data_p2[31:0];
wire r_en1c;
wire w_en1c;
wire r_en2c;
wire w_en2c;
wire r_en1;
wire w_en1;
wire r_en2;
wire w_en2;
reg[11:0] adress1;
reg[11:0] adress2;
reg[11:0] end_prim;
reg[31:0]data1;
reg[31:0]data2;
reg[9:0] end1;
reg[9:0] end2;
wire ren_mem;
wire wen_mem;
reg[31:0] dado_mem;
reg[31:0] data_men;

integer i;
integer achou1;
integer achou2;
integer prioridade;

reg FSM[2:0];
reg FSMG [2:0];


achou = 0;



    always@(posedge clk) begin
	 
	 if(rst == 1)
	 begin
	 
	 stall1 = 0;
	 stall2 = 0;
	 
	 for(i = 0; i < 256; i = i + 1)
	 begin

	cache_table1[i] = 0;
	cache_valido1[i] = 0;
	
	cache_table1[i] = 0;
	cache_valido1[i] = 0;

	 end


	end //end rst
	 
	 

mips_multi P1(.stall(stall),.clk(CLOCK_50),.rst(KEY[0],
				 .saida_cache(data_p1)), 
             .address1(adress1),
				 .data1(data1),
				 .r_en1(r_en1),
				 .w_en1(w_en1);

mips_multi P1(.stall(stall),.clk(CLOCK_50),.rst(KEY[0],
				  .saida_cache(data_p2)), 
             .address2(adress2),
				 .data2(data2),
				 .r_en2(r_en2),
				 .w_en2(w_en2);



	if(stall1 == 1 || stall2 == 1)
	
	if (adress1[11:10] == cache_table1[adress1[9:2]] && cache_valido1 == 1)
	begin
	
	achou1 = 1;
	FSMG = 3'b001;
	
	end
	
	if (adress2[11:10] == cache_table2[adress2[9:2]] && cache_valido2 == 1)
	begin
	
	achou2 = 1;
	FSMG = 3'b001;
	
	
	end

	if(FSMG = 3'b001)
	begin //falta end

	 if (achou1 == 1 && achou2 == 1)
	 begin
	 
	 end1 = adress1[1:0] + adress1[9:2];
	 
	 
if(w_en1 == 1)
begin

end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
data_1 = data1
FSM = 3'b001;
w_en1c = 1;
r_en1c = 0;


if(FSM == 3'b001)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data_c1;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina

end
	 
if(r_en1 == 1)
begin

data_1 = data1;   //le da cache1
end1 = adress1[9:2] + adress1[1:0];
w_en1c = 0;
r_en1c = 1;
FSM = 3'b001;


if(FSM == 3'b010)
begin

data_p1 = data_c1; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall1 = 0; //termina
	
	 
	 end
	 
	  if (achou1 == 0 && achou2 == 1)
	  begin
	 
	 end2 = adress2[1:0] + adress2[9:2];
	 
	 
if(w_en2 == 1)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data2;
FSM = 3'b001;
w_en2c = 1;
r_en2c = 0;


if(FSM == 3'b001)
begin

end_prim = address2; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data_c2;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall2 = 0; //termina

end
	 
if(r_en2 == 1)
begin

data_2 = data2;   //le da cache1
end2 = adress2[9:2] + adress2[1:0];
w_en2c = 0;
r_en2c = 1;
FSM = 3'b001;


if(FSM == 3'b010)
begin

data_p2 = data_c2; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall2 = 0; //termina
	 
	 
	 end
	 
	 if (achou1 == 0 && achou2 == 1)
	 begin
	 
	 if(r_en1 == 1)
begin

end_prim = address1;    //le da memoria principal
ren_mem = r_en1;
wen_mem = 0;
FSM = 3'b001;
prioridade = 0;

if(FSM == 3'b001)
begin

data_1 = dado_mem;   //escreve na cache1
end1 = adress1[9:2] + adress1[1:0];
w_en1c = 1;
r_en1c = 0;
FSM = 3'b010;

if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b011

end

if(FSM = 3'b011)
begin


end1 = adress1[9:2] + adress1[1:0]; //manda ler da cache1
w_en1c = 0;
r_en1c = 1;
stall1 = 0;
FSM = 3'b100

end

if(FSM == 3'b100)
begin

data_p1 = data_c1; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall1 = 0; //termina


end

if(w_en2 == 1)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data2;
FSM = 3'b001;
w_en2c = 1;
r_en2c = 0;


if(FSM == 3'b001)
begin

end_prim = address2; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data_c2;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall2 = 0; //termina

end
	 
if(r_en2 == 1)
begin

data_2 = data2;   //le da cache1
end2 = adress2[9:2] + adress2[1:0];
w_en2c = 0;
r_en2c = 1;
FSM = 3'b001;


if(FSM == 3'b010)
begin

data_p2 = data_c2; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall2 = 0; //termina





end



end

if(w_en1 == 1)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data1;
FSM = 3'b001;
prioridade = 0;

if(FSM == 3'b001)
begin

end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
data_1 = data_mem;
w_en1c = 1;
r_en1c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina

end


end
	 
	 
	 end
	 
	 
	 if (achou1 == 1 && achou2 == 0)
	 begin
	 
	 if(w_en1 == 1)
begin

end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
data_1 = data1
FSM = 3'b001;
w_en1c = 1;
r_en1c = 0;


if(FSM == 3'b001)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data_c1;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina

end
	 
if(r_en1 == 1)
begin

data_1 = data1;   //le da cache1
end1 = adress1[9:2] + adress1[1:0];
w_en1c = 0;
r_en1c = 1;
FSM = 3'b001;


if(FSM == 3'b010)
begin

data_p1 = data_c1; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall1 = 0; //termina
	 
	 if(r_en2 == 1)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data2;
FSM = 3'b001;

if(FSM == 3'b001)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data_mem;
w_en2c = 1;
r_en2c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina
end

end


if(w_en2 == 1)
begin

end_prim = address2; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data2;
FSM = 3'b001;

if(FSM == 3'b001)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data_mem;
w_en2c = 1;
r_en2c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall2 = 0; //termina
end



end 



end 
	 
	 
	 end
	 
	 
	
if (achou1 == 0 && achou2 == 0)
begin


prioridade = 1;

if(r_en1 == 1)
begin

end_prim = address1;    //le da memoria principal
ren_mem = r_en1;
wen_mem = 0;
FSM = 3'b001;
prioridade = 0;

if(FSM == 3'b001)
begin

data_1 = dado_mem;   //escreve na cache1
end1 = adress1[9:2] + adress1[1:0];
w_en1c = 1;
r_en1c = 0;
FSM = 3'b010;

if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b011

end

if(FSM = 3'b011)
begin


end1 = adress1[9:2] + adress1[1:0]; //manda ler da cache1
w_en1c = 0;
r_en1c = 1;
stall1 = 0;
FSM = 3'b100

end

if(FSM == 3'b100)
begin

data_p1 = data_c1; //manda dado pro banco de registradores em P1
FSM = 3'b000;
stall1 = 0; //termina


end





end



end

if(w_en1 == 1)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data1;
FSM = 3'b001;
prioridade = 0;

if(FSM == 3'b001)
begin

end1 = adress1[9:2] + adress1[1:0]; //escreve na cache1
data_1 = data_mem;
w_en1c = 1;
r_en1c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table1[adress1[9:2]] = adress1[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina

end


end

if(prioridade == 0)
begin

if(r_en2 == 1)
begin

end_prim = address1; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data2;
FSM = 3'b001;

if(FSM == 3'b001)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data_mem;
w_en2c = 1;
r_en2c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall1 = 0; //termina
end

end


if(w_en2 == 1)
begin

end_prim = address2; //escreve na memoria principal
ren_mem = 0;
wen_mem = 1;
data_mem = data2;
FSM = 3'b001;

if(FSM == 3'b001)
begin

end2 = adress2[9:2] + adress2[1:0]; //escreve na cache1
data_2 = data_mem;
w_en2c = 1;
r_en2c = 0;
FSM = 3'b010;
end
if(FSM = 3'b010)
begin

cache_table2[adress2[9:2]] = adress2[11:10]; //atualiza cache table
FSM = 3'b000;
stall2 = 0; //termina
end



end 



end 


end //end achou = 0

end


cache1 c1(		
		.address(end1),
		.clock(clk),
		;data(data_1),
		.rden	(r_en1c)
		.wren(w_en1c)
		.q(data_c1)
	);
	

cache1 c2(		
		.address(end2),
		.clock(clk),
		;data(data_2),
		.rden	(r_en2c)
		.wren(w_en2c)
		.q(data_c2)
	);
	
memoria_principal mp bn(		
		.address(end_prim)
		),
		.clock(clk),
		;data(data_men),
		.rden	(ren_mem)
		.wren(wen_mem)
		.q(dado_mem)
	);


end



endmodule
