

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


wire stall;
reg [1:0] cache_table1[255:0];
reg cache_valido1[255:0];

reg [1:0] cache_table2[255:0];
reg cache_valido2[255:0];

reg data_c1[31:0];
reg data_c2[31:0];
wire r_en1;
wire w_en1;
wire r_en2;
wire w_en2;
reg[11:0] adress1;
reg[11:0] adress2;
reg[31:0]data1;
reg[31:0]data2;
reg[9:0] end1;
reg[9:0] end2;
wire ren_mem;
wire wen_mem;
reg[31:0] dado_mem;
reg[31:0] data_men;

integer i;
integer achou;


achou = 0;



    always@(posedge clk) begin
	 
	 if(rst == 1)
	 begin
	 
	 for(i = 0; i < 256; i = i + 1)
	 begin

	cache_table1[i] = 0;
	cache_valido1[i] = 0;
	
	cache_table1[i] = 0;
	cache_valido1[i] = 0;

	 end


	end //end rst
	 
	 

mips_multi P1(.stall(stall),.clk(CLOCK_50),.rst(KEY[0],
				 .saida_cache(data_c1)), 
             .address1(adress1),
				 .data1(data1),
				 .r_en1(r_en1),
				 .w_en1(w_en1);

mips_multi P1(.stall(stall),.clk(CLOCK_50),.rst(KEY[0],
				  .saida_cache(data_c2)), 
             .address2(adress2),
				 .data2(data2),
				 .r_en2(r_en2),
				 .w_en2(w_en2);

if(r_en1 == 1 || r_en2 == 1 || w_en1 == 1 || w_en2 == 1)	
begin

stall = 1;

end


	 for(i = 0; i < 256; i = i + 1)
	 begin

	 if (adress1[11:10] == cache_table1[i])
	 begin
	 
	 achou = 1;
	 if(w_en1 == 1)
	 begin
	 
	 end1 = adress1[0:9];
	 data_mem = data;
	 
	 end
	 
	 if(r_en == 1)
	 begin
	 
	 
	 end
	 
	 
	 end
	 
	 if (adress2 == cache_table2[i])
	 begin
	 
	 
	 end
	 
	 
	 end 
	
if (achou == 0)
begin



end


cache1 c1(		
		.address(end1),
		.clock(clk),
		;data(data_1),
		.rden	(r_en1)
		.wren(w_en1)
		.q(data_c1)
	);
	

cache1 c2(		
		.address(end2),
		.clock(clk),
		;data(data_2),
		.rden	(r_en2)
		.wren(w_en2)
		.q(data_c2)
	);
	
memoria_principal mp bn(		
		.address(end),
		.clock(clk),
		;data(data_men),
		.rden	(ren_mem)
		.wren(wen_mem)
		.q(dado_mem)
	);


end



endmodule
