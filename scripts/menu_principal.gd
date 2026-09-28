extends Control

func _ready():
	$PainelBestiario/ListaVisagens.clear()
	for monstro in Global.bestiario:
		$PainelBestiario/ListaVisagens.add_item(monstro["nome"])
		
func _on_iniciar_button_pressed() -> void:
	Global.parar_musica_tema()
	get_tree().change_scene_to_file("res://scenes/fase_principal.tscn")
	
func _on_sair_button_pressed() -> void:
	get_tree().quit()

func _on_records_button_pressed() -> void:
	var texto_podio = "--- TOP 3 VISAGENS ESPANTADAS ---\n\n"
	
	for i in range(3):
		var registro = Global.top_recordes[i]
		var posicao = str(i + 1) + "º Lugar: "
		
		if registro["pontuacao"] > 0:
			texto_podio += posicao + str(registro["pontuacao"]) + " visagens em " + registro["data"] + "\n\n"
		else:
			texto_podio += posicao + "Ainda não desbravado...\n\n"
	
	$PainelRecorde/TextoRecorde.text = texto_podio
	$PainelRecorde.show()

func _on_button_pressed() -> void:
	$PainelRecorde.hide()

func _on_options_button_pressed() -> void:
	$PainelOpcoes/SliderVolume.value = Global.volume_geral
	$PainelOpcoes/SliderBrilho.value = Global.brilho_tela
	$PainelOpcoes.show()

func _on_fechar_pressed() -> void:
	$PainelOpcoes.hide()

func _on_slider_volume_value_changed(value: float) -> void:
	Global.volume_geral = value
	
	var indice_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(indice_bus, linear_to_db(value))
	
func _on_slider_brilho_value_changed(value: float) -> void:
	Global.brilho_tela = value
	
	modulate = Color(value, value, value, 10)


func _on_lista_visagens_item_selected(index: int) -> void:
	var monstro_selecionado = Global.bestiario[index]
	
	$PainelBestiario/NomeVisagem.text = monstro_selecionado["nome"]
	$PainelBestiario/DescricaoVisagem.text = monstro_selecionado["descricao"]
	$PainelBestiario/FotoVisagem.texture = monstro_selecionado["textura"]


func _on_visagens_button_pressed() -> void:
	$PainelBestiario.show()


func _on_botao_fechar_pressed() -> void:
	$PainelBestiario.hide()
