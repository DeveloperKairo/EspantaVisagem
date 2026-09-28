extends Node2D

@onready var molde_monstro = preload("res://scenes/monstro.tscn")
@onready var molde_irma = preload("res://scenes/irma_coque.tscn")
var visagens_espantadas = 0
var cargas_de_fe = 0
var escudo_ativo = false
var tempo_spawn_atual = 2.0
var tempo_ataque_atual = 3.0
var feixe_lanterna: Panel

func _ready():
	modulate = Color(Global.brilho_tela, Global.brilho_tela, Global.brilho_tela, 1.0)
	feixe_lanterna = Panel.new()
	feixe_lanterna.size = Vector2(300, 300)
	feixe_lanterna.mouse_filter = Control.MOUSE_FILTER_IGNORE
	feixe_lanterna.hide()
	
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(1.0, 1.0, 0.7, 0.35)
	
	estilo.corner_radius_top_left = 500
	estilo.corner_radius_top_right = 500
	estilo.corner_radius_bottom_left = 500
	estilo.corner_radius_bottom_right = 500
	feixe_lanterna.add_theme_stylebox_override("panel", estilo)
	
	$CamadaUI.add_child(feixe_lanterna)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:	
			if event.pressed:
				$Jogador/AnimationPlayer.play("Ligado")
				
				feixe_lanterna.position = event.position - (feixe_lanterna.size / 2.0)
				feixe_lanterna.show()
			else:
				$Jogador/AnimationPlayer.play("Desligado")
				feixe_lanterna.hide()
				
	if event is InputEventKey:
		if event.keycode == KEY_X and event.pressed:
			invocar_irma_do_coque()
		if event.keycode == KEY_Z and event.pressed:
			ativar_escudo()
			
func ativar_escudo():
	if cargas_de_fe >= 3 and not escudo_ativo:
		cargas_de_fe -= 3
		escudo_ativo = true
		$CamadaUI/TextoFe.text = "Cargas de Fé: " + str(cargas_de_fe)
		
		mostrar_aviso("Irmã do Coque invocou o Escudo da Fé!")
		tocar_animacao_irma()
	elif escudo_ativo:
		mostrar_aviso("Você já está protegido!")
	else:
		mostrar_aviso("Fé insuficiente para o escudo (necessário 3).")
				
func invocar_irma_do_coque():
	if cargas_de_fe >= 5:
		mostrar_aviso("MILAGRE! A Irmã do Coque ergue a cruz e limpou a caatinga!")
		tocar_animacao_irma()
		
		$SomMilagre.play()
		
		var monstros_na_tela = get_tree().get_nodes_in_group("visagens")
		for monstro in monstros_na_tela:
			monstro.queue_free()
			
		cargas_de_fe = 0
		$CamadaUI/TextoFe.text = "Cargas de Fé: " + str(cargas_de_fe)
	else:
		mostrar_aviso("Você não tem Cargas de Fé suficientes ainda!")

func _on_cronometro_susto_timeout() -> void:
	var novo_monstro = molde_monstro.instantiate()
	var lista_de_pontos = $PontosDeSurgimento.get_children()
	var ponto_sorteado = lista_de_pontos.pick_random()
	novo_monstro.position = ponto_sorteado.position
	
	novo_monstro.get_node("TimerFuga").wait_time = tempo_ataque_atual
	
	add_child(novo_monstro)
	
func mostrar_aviso(mensagem: String):
	$CamadaUI/TextoAvisos.text = mensagem
	$CamadaUI/TextoAvisos.show()
	
	await get_tree().create_timer(2.0).timeout
	$CamadaUI/TextoAvisos.hide()
	
func tocar_animacao_irma():
	var nova_irma = molde_irma.instantiate()
	
	$CamadaUI.add_child(nova_irma)
	
	nova_irma.position = $Jogador.position + Vector2(150, -50)
	
	nova_irma.get_node("AnimationPlayer").play("aparecer_e_sumir")
	
func criar_novo_spawner():
	pass
	
func criar_efeito_clique(posicao_do_mouse: Vector2):
	var circulo = Panel.new()
	circulo.size = Vector2(20, 20)
	
	circulo.pivot_offset = circulo.size / 2.0
	circulo.position = posicao_do_mouse - circulo.pivot_offset
	
	circulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(1.0, 1.0, 0.0, 0.5)
	estilo.corner_radius_top_left = 100
	estilo.corner_radius_top_right = 100
	estilo.corner_radius_bottom_left = 100
	estilo.corner_radius_bottom_right = 100
	circulo.add_theme_stylebox_override("panel", estilo)
	
	$CamadaUI.add_child(circulo)
	var tween = create_tween()
	tween.tween_property(circulo, "scale", Vector2(3.0, 3.0), 0.3)
	tween.parallel().tween_property(circulo, "modulate:a", 0.0, 0.3)
	tween.tween_callback(circulo.queue_free)
	
func espantar_visagem():
	visagens_espantadas += 1
	$CamadaUI/TextoVisagens.text = "Visagens Espantadas: " + str(visagens_espantadas)
	
	if tempo_spawn_atual > 1:
		tempo_spawn_atual -= 0.05
		$CronometroSusto.wait_time = tempo_spawn_atual
	
	if tempo_ataque_atual > 1:
		tempo_ataque_atual -= 0.05
		
	var geradores_extras = get_tree().get_nodes_in_group("spawners_extras").size()
	if visagens_espantadas % 30 == 0 and (geradores_extras +1) <6:
		criar_novo_spawner()
	
	if visagens_espantadas % 5 == 0:
		if cargas_de_fe < 5:
			cargas_de_fe += 1
			$CamadaUI/TextoFe.text = "Cargas de Fé: " + str(cargas_de_fe)
			
			if cargas_de_fe == 3:
				mostrar_aviso("3 Cargas! Aperte Z para ativar o Escudo da Fé!")
			elif cargas_de_fe == 5:
				mostrar_aviso("5 Cargas! Aperte X para chamar a Irmã do Coque!")
			else:
				mostrar_aviso("Você ganhou uma Carga de Fé!")
func tomar_susto(dados_do_monstro_que_atacou):
	if escudo_ativo:
		escudo_ativo = false
		$SomEscudo.play()
		$CamadaUI/BrilhoEscudo.show()
		await get_tree().create_timer(1.0).timeout
		$CamadaUI/BrilhoEscudo.hide()
		return
		
	Global.registrar_pontuacao(visagens_espantadas)
		
	get_tree().paused = true
	
	$SomSusto.play()
	
	$CamadaUI/TelaMorte/TextoFrase.text = dados_do_monstro_que_atacou["frase_morte"]
	$CamadaUI/TelaMorte/FotoMonstro.texture = dados_do_monstro_que_atacou["textura"]
	$CamadaUI/TelaMorte/TextoNome.text = dados_do_monstro_que_atacou["nome"]
	$CamadaUI/TelaMorte/TextoDescricao.text = dados_do_monstro_que_atacou["descricao"]
	
	$CamadaUI/TelaMorte/FotoMonstro.hide()
	$CamadaUI/TelaMorte/TextoNome.hide()
	$CamadaUI/TelaMorte/TextoDescricao.hide()
	$CamadaUI/TelaMorte/BotaoRecomecar.hide()
	$CamadaUI/TelaMorte/BotaoMenu.hide()
	
	$CamadaUI/TelaMorte.show()
	
	await get_tree().create_timer(2.0).timeout
	$CamadaUI/TelaMorte/FotoMonstro.show()
	$CamadaUI/TelaMorte/TextoNome.show()
	$CamadaUI/TelaMorte/TextoDescricao.show()
	$CamadaUI/TelaMorte/BotaoRecomecar.show()
	$CamadaUI/TelaMorte/BotaoMenu.show()
	


func _on_botao_recomecar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_botao_menu_pressed() -> void:
	Global.tocar_musica_tema()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
