inicio: addi $t5, $t5, 67
addi $t0, $t0, 100 #t0 = 100
addi $t1, $t1, 33 #t1 = 33
sub $t3, $t0, $t1 #t3 = 67
sw $t3, ($t2) #armazena 67 na posicao zero
beq $t5, $t3, tomado #manda pra linha 8 -> deve ser tomado
add $t0, $t0, $t0 #não deveria ser executado
tomado: add $t5, $t5, $t5 #dobra o valor de t5
beq $t0, $t5, inicio #o normal seria um ser o dobro do outro. se for tomado, entra em loop, mas nao deve ser