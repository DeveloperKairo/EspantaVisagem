extends Area2D

var texturas_monstros = [
	preload("res://assets/sprites/EtQuixada.png"),
	preload("res://assets/sprites/Lobisomem.png"),
	preload("res://assets/sprites/CabeloCao.png"),
	preload("res://assets/sprites/MeninaGato.png"),
	preload("res://assets/sprites/RasgaMortalha.png"),
	preload("res://assets/sprites/VaqueiroFantasma.png"),
	preload("res://assets/sprites/VelhoSaco.png"),
	preload("res://assets/sprites/PernaCabeluda.png"),
	preload("res://assets/sprites/NoivaFantasma.png")
]

var dados_do_monstro = {}

func _ready():
	add_to_group("visagens")
	dados_do_monstro = Global.bestiario.pick_random()
	
	$Sprite2D.texture = dados_do_monstro["textura"]
	
	var tamanho_da_imagem = $Sprite2D.texture.get_size()
	var nova_hitbox = RectangleShape2D.new()
	nova_hitbox.size = tamanho_da_imagem
	
	$CollisionShape2D.shape = nova_hitbox

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().current_scene.espantar_visagem()
			queue_free()


func _on_timer_fuga_timeout() -> void:
	get_tree().current_scene.tomar_susto(dados_do_monstro)
