.data
SPACESHIP_POS:	.half 0,0				# x, y
CANNON_POS:		.half 40,170			# (x, y) Posicao do Canhao
CANNON_ANGLE:	.half 0				# Angle 0 -> 15 | 1 -> 30 | 2 -> 45 | 3 -> 60
MUNITION_POS:	.half	88,180			# POS Inicial (X,Y) 15,30,45,60

.text
SETUP:	la 	a0, background			# carrega o endereco do sprite 'background' em a0
		li 	a1, 0					# x = 0
		li 	a2, 0					# y = 0
		li 	a3, 0					# frame = 0
		call 	PRINT					# imprime o sprite
		li	a3, 1					# frame = 1
		call 	PRINT					# imprime o sprite
		
		# Random POS spaceship (Multiplo de 4)
		la 	t0, SPACESHIP_POS			# carrega o endereco da posicao da espaco nave
		call 	RANDOM_POS_X			# gera um inteiro aleatório para x
		sh	a0, 0(t0)				# salva o inteiro aleatório em RANDOM_POS_X
		call	RANDOM_POS_Y			# gera um inteiro aleatório para y
		sh	a0, 2(t0)				# salva o inteiro aleatório em RANDOM_POS_Y
	
		
GAMELOOP:	
		xori	s0, s0, 1
		call	CHOOSE_CANNON_ANGLE		# carrega o endereço do sprite 'canhao' em a0 no angulo correto
		la	t1, CANNON_POS			# posicao do canhao
		lh 	a1, 0(t1)				# x = 0
		lh 	a2, 2(t1)				# y = 0
		mv	a3, s0				# frame atual
		call 	PRINT					# imprime o sprite
		
		# Random SpaceShip
		la	t1, SPACESHIP_POS	
		lh 	a1, 0(t1)				# carrega a posicao x da spaceship em a1
		lh 	a2, 2(t1)				# carrega a posicao y da spaceship em a2
		la 	a0, spaceship			# carrega o endereço do sprite 'canhao' em a0
		mv	a3, s0				# frame atual
		call 	PRINT					# imprime o sprite
		
		li 	t0, 0xFF200604			# carrega em t0 o endereco de troca de frame
		sw 	s0, 0(t0)				# mostra o sprite pronto para o usuario
		
		call	READKEY				# chama leitura de teclado
		
SHOOT:	
		# Solta o tiro
		la	t1, MUNITION_POS			# carrega o endereco da posicao da municao
		lh	a1, 0(t1)				# carrega em a1 a posicao x da municao
		lh	a2, 2(t1)				# carrega em a2 a posicao y da municao
		la 	a0, munition			# carrega o endereço do sprite 'canhao' em a0
		mv	a3, s0				# frame atual
		call 	PRINT					# imprime o sprite
		li 	a7,32					# sleep
		li	a0, 2000				# wait 2000ms
		ecall
		
GAMEOVER:	
		# Explode SpaceShip
		la	t1, SPACESHIP_POS	
		lh 	a1, 0(t1)				# carrega a posicao x da spaceship em a1
		lh 	a2, 2(t1)				# carrega a posicao y da spaceship em a2
		la 	a0, explosion			# carrega o endereço do sprite 'canhao' em a0
		mv	a3, s0				# frame = 0
		call 	PRINT					# imprime o sprite
		li 	a7,	32				# sleep
		li	a0, 1000				# wait 2000ms
      	ecall						
		la	a0, gameover			# carrega o endereco do sprite 'gameover' em a0
		li	a1, 0					# x = 0
		li	a2, 0					# y = 0
		li 	a3, 0					# frame = 0
		li 	t0, 0xFF200604			# carrega em t0 o endereco de troca de frame
		li	s0, 0					# frame pro usuario 0
		sw 	s0, 0(t0)				# mostra o sprite pronto para o usuario
		call	PRINT					# imprime o sprite
		li 	a7,	32				# sleep
		li	a0, 1000				# wait 2000ms
		ecall
		j	SETUP					# retorna do loop do jogo
		
		# Lê teclado	
READKEY:
		li 	a7,	12				# leitura do teclado
      	ecall						# le o teclado
      	li	t0, 'w'				# carrega 'w' para comparação
	   	beq	a0, t0, WKEYPRESSED		# Se for igual vai para WKEYPRESSED
      	li	t0, 's'				# carrega 's' para comparação
      	beq	a0, t0, SKEYPRESSED		# se for igual vai para SKEYPRESSED
      	li	t0, ' '				# carrega ' ' (barrra de espaco) para comparação
      	beq	a0, t0, SHOOT			# se for igual vai para SHOOT
      	j	GAMELOOP				# retorna para o LOOP do jogo
      	
WKEYPRESSED:
		la	t1, CANNON_ANGLE			# carrega o endereco do angulo do canhao em t1
		li	t2, 3					# limite de 3
		lh 	a1, 0(t1)				# carrega o angulo do canhao em a1
		bge	a1, t2, GAMELOOP			# se for maior ou igual a 3 (maior ângulo possível) retorna pro loop do jogo
		addi	a1, a1, 1				# soma 1 para variacoes do angulo do canhao
		sh	a1, 0(t1)				# salva o angulo atual no endereco CANNON_ANGLE
		j	GAMELOOP				# retorna para o LOOP do jogo
		
SKEYPRESSED:
		la	t1, CANNON_ANGLE			# carrega o endereco do angulo do canhao em t1
		li	t2, 0					# carrega 0 em t2
		lh 	a1, 0(t1)				# carrega o angulo do canhao em a1
		ble	a1, t2, GAMELOOP			# se for menor ou igual a 0 (menor ângulo possível)
		addi	a1, a1, -1				# subtrai 1 para variar o angulo do canhao
		sh	a1, 0(t1)				# salva o angulo atual no endereco CANNON_ANGLE
		j	GAMELOOP				# retorna para o LOOP do jogo
	
CHOOSE_CANNON_ANGLE:
		la	t1, CANNON_ANGLE			# carrega o endereco do angulo do canhao em t1
		lh 	a1, 0(t1)				# carrega o angulo do canhao em a1
		li	t2, 0					# 0
		beq	a1, t2, ANGLE_90			# se for igual a 0 carrega a imagem referente a 90 graus
		li	t2, 1					# 1
		beq	a1, t2, ANGLE_105			# se for igual a 1 carrega a imagem referente a 105 graus
		li	t2, 2					# 2
		beq	a1, t2, ANGLE_120			# se for igual a 2 carrega a imagem referente a 120 graus
		li	t2, 3					# 3
		beq	a1, t2, ANGLE_135			# se for igual a 3 carrega a imagem referente a 135 graus
		ret
		
ANGLE_90:
		la	a0, canhao90			# carrega o endereco da imagem do canhao em 90
		la	t1, MUNITION_POS			# carrega o endereco da municao do canhao em t1
		li	t2, 88				# carrega o valor de x da bala no angulo de 90
		sh 	t2, 0(t1)				# carrega o valor em MUNITION_POS
		li	t2, 180				# carrega o valor de y da bala no angulo de 90
		sh 	t2, 2(t1)				# carrega o valor em MUNITION_POS(2)
		ret
ANGLE_105:
		la	a0, canhao105			# carrega o endereco da imagem do canhao em 105
		la	t1, MUNITION_POS			# carrega o endereco da municao do canhao em t1
		li	t2, 88				# carrega o valor de x da bala no angulo de 105
		sh 	t2, 0(t1)				# carrega o valor em MUNITION_POS
		li	t2, 170				# carrega o valor de y da bala no angulo de 105
		sh 	t2, 2(t1)				# carrega o valor em MUNITION_POS(2)
		ret
ANGLE_120:
		la	a0, canhao120			# carrega o endereco da imagem do canhao em 120
		la	t1, MUNITION_POS			# carrega o endereco da municao do canhao em t1
		li	t2, 84				# carrega o valor de x da bala no angulo de 120
		sh 	t2, 0(t1)				# carrega o valor em MUNITION_POS
		li	t2, 160				# carrega o valor de y da bala no angulo de 120
		sh 	t2, 2(t1)				# carrega o valor em MUNITION_POS(2)
		ret
ANGLE_135:
		la	a0, canhao135			# carrega o endereco da imagem do canhao em 135
		la	t1, MUNITION_POS			# carrega o endereco da municao do canhao em t1
		li	t2, 80				# carrega o valor de x da bala no angulo de 135
		sh 	t2, 0(t1)				# carrega o valor em MUNITION_POS
		li	t2, 156				# carrega o valor de y da bala no angulo de 135
		sh 	t2, 2(t1)				# carrega o valor em MUNITION_POS(2)
		ret
		
		#################################################
		#	a0 = endereço imagem				#
		#	a1 = x						#
		#	a2 = y						#
		#	a3 = frame (0 ou 1)				#
		#################################################
		#	t0 = endereco do bitmap display		#
		#	t1 = endereco da imagem				#
		#	t2 = contador de linha				#
		# 	t3 = contador de coluna				#
		#	t4 = largura					#
		#	t5 = altura						#
		#################################################

PRINT:	li 	t0,0xFF0				# carrega 0xFF0 em t0
		add 	t0,t0,a3				# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli 	t0,t0,20				# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add 	t0,t0,a1				# adiciona x ao t0
		
		li 	t1,320				# t1 = 320
		mul 	t1,t1,a2				# t1 = 320 * y
		add 	t0,t0,t1				# adiciona t1 ao t0
		
		addi 	t1,a0,8				# t1 = a0 + 8
		
		mv 	t2,zero				# zera t2
		mv 	t3,zero				# zera t3
		
		lw 	t4,0(a0)				# carrega a largura em t4
		lw 	t5,4(a0)				# carrega a altura em t5
		
PRINT_LINHA:	
		lw 	t6,0(t1)				# carrega em t6 uma word (4 pixeis) da imagem
		sw 	t6,0(t0)				# imprime no bitmap a word (4 pixeis) da imagem
		
		addi 	t0,t0,4				# incrementa endereco do bitmap
		addi 	t1,t1,4				# incrementa endereco da imagem
		
		addi 	t3,t3,4				# incrementa contador de coluna
		blt 	t3,t4,PRINT_LINHA			# se contador da coluna < largura, continue imprimindo

		addi 	t0,t0,320				# t0 += 320
		sub 	t0,t0,t4				# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv 	t3,zero				# zera t3 (contador de coluna)
		addi 	t2,t2,1				# incrementa contador de linha
		bgt 	t5,t2,PRINT_LINHA			# se altura > contador de linha, continue imprimindo
		
		ret						# retorna
		
RANDOM_POS_X:	
		li	a7, 42				# inteiro aleatorio
		li	a1, 48				# limitacao para gerar o inteiro baseado em x
		ecall						# gero inteiro randomico
		li	s1, 4					# carrega 4 em s1
		mul	a0, a0, s1				# multiplica o valor randomico gerado por 4 para gerar um multiplo de 4
		ret						# retorna pro endereco anterior
		
RANDOM_POS_Y:	
		li	a7, 42				# inteiro aleatorio
		li	a1, 18				# limitacao para gerar o inteiro baseado em y
		ecall						# gera o inteiro randomico
		li	s1, 4					# carrega 4 em s1
		mul	a0, a0, s1				# multiplica o valor randomico gerado por 4 para gerar um multiplo de 4
		ret						# retorna pro endereco anterior

EXIT:		li 	a7, 10				# termina o programa
		ecall						# fim
	
.data
.include "gameImages/background.data"
.include "gameImages/canhao90.data"
.include "gameImages/canhao105.data"
.include "gameImages/canhao120.data"
.include "gameImages/canhao135.data"
.include "gameImages/gameover.data"
.include "gameImages/spaceship.data"
.include "gameImages/explosion.data"
.include "gameImages/munition.data"
