extends Node

var top_recordes = [
	{"pontuacao": 0, "data": "--/--/---- --:--"},
	{"pontuacao": 0, "data": "--/--/---- --:--"},
	{"pontuacao": 0, "data": "--/--/---- --:--"}
]
var bestiario = [
	{
		"textura": preload("res://assets/sprites/EtQuixada.png"),
		"nome": "ET de Quixadá",
		"frase_morte": "Você foi abduzido pelas luzes do monólito...",
		"descricao": "Dizem que ele aparece quando a noite cai na serra. Fique atento aos feixes de luz cruzando o céu do sertão."
	},
	{
		"textura": preload("res://assets/sprites/Lobisomem.png"),
		"nome": "Lobisomem",
		"frase_morte": "As garras rasgaram a noite e o seu destino...",
		"descricao": "A maldição do sétimo filho. Nas noites de lua cheia, a besta uiva faminta, escondida entre os mandacarus."
	},
	{
		"textura": preload("res://assets/sprites/NoivaFantasma.png"),
		"nome": "Noiva Fantasma",
		"frase_morte": "Até que a morte nos separe... e ela separou.",
		"descricao": "Vaga pelas estradas de terra procurando o amor que nunca chegou ao altar. O frio sempre anuncia sua chegada."
	},
	{
		"textura": preload("res://assets/sprites/CabeloCao.png"),
		"nome": "Cabelo de Cão",
		"frase_morte": "O rosnado no escuro foi a última coisa que você ouviu...",
		"descricao": "Uma criatura feroz e rastejante que se esconde nas moitas secas. Seu cheiro terrível avisa que já é tarde demais."
	},
	{
		"textura": preload("res://assets/sprites/MeninaGato.png"),
		"nome": "Menina Gato",
		"frase_morte": "Um miado agudo ecoou, mas os olhos na escuridão não eram de um felino...",
		"descricao": "Ágil, silenciosa e perturbadora. Ela espreita nos telhados de taipa, brincando com a sanidade de quem a observa."
	},
	{
		"textura": preload("res://assets/sprites/RasgaMortalha.png"),
		"nome": "Rasga-Mortalha",
		"frase_morte": "O pano foi rasgado, e o seu nome foi chamado para o além...",
		"descricao": "A coruja agourenta. Quando seu grito rasga o silêncio da noite cearense, é sinal de que a morte não vai voltar de mãos vazias."
	},
	{
		"textura": preload("res://assets/sprites/VaqueiroFantasma.png"),
		"nome": "Vaqueiro Fantasma",
		"frase_morte": "O berrante tocou, mas você já fazia parte do rebanho dos mortos...",
		"descricao": "Condenado a cavalgar pela eternidade na seca. Onde ele passa, o gado chora, a terra racha e o medo se instala."
	},
	{
		"textura": preload("res://assets/sprites/VelhoSaco.png"),
		"nome": "Velho do Saco",
		"frase_morte": "O Velho do Saco capturou você...",
		"descricao": "Um andarilho sombrio que vaga procurando os desavisados. O que tem dentro do saco? Ninguém que descobriu voltou para contar."
	},
	{
		"textura": preload("res://assets/sprites/PernaCabeluda.png"),
		"nome": "Perna Cabeluda",
		"frase_morte": "A Perna Cabeluda te chutou...",
		"descricao": "Uma lenda bizarra e violenta. Surge das sombras, rápida e letal, para golpear e arrastar quem fica vagando tarde da noite."
	}
]
var volume_geral = 1.0
var brilho_tela = 1.0
var toca_fitas = AudioStreamPlayer.new()

func _ready():
	var musica = preload("res://assets/audios/menu.mp3")
	toca_fitas.stream = musica
	add_child(toca_fitas)
	tocar_musica_tema()

func registrar_pontuacao(nova_pontuacao: int):
	if nova_pontuacao == 0:
		return
		
	var tempo = Time.get_datetime_dict_from_system()
	var str_data = "%02d/%02d/%04d %02d:%02d" % [tempo.day, tempo.month, tempo.year, tempo.hour, tempo.minute]
	var novo_registro = {"pontuacao": nova_pontuacao, "data": str_data}
	
	top_recordes.append(novo_registro)
	
	top_recordes.sort_custom(func(a, b): return a["pontuacao"] > b["pontuacao"])
	top_recordes.resize(3)
	
func parar_musica_tema():
	toca_fitas.stop()
	
func tocar_musica_tema():
	if not toca_fitas.playing:
		toca_fitas.play()
