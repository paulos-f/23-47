extends Node3D

@onready var player: FirstPersonPlayer = $Player
@onready var hud: GameHUD = $HUD


func _ready() -> void:
	player.interaction_prompt_changed.connect(hud.set_interaction_prompt)
	player.message_requested.connect(hud.show_message)
	GameManager.message_requested.connect(hud.show_message)
	NarratorManager.line_spoken.connect(hud.show_narrator)
	TimeManager.minute_changed.connect(hud.set_clock)
	KnowledgeManager.loop_count_changed.connect(hud.set_loop_count)
	hud.set_loop_count(KnowledgeManager.loop_count)
	hud.set_objective("Objetivo: investigue os circuitos do Arquivo e do Laboratório.")
	TimeManager.configure_loop(23, 35, 0, 0, 7.0)
	TimeManager.start_loop()
	hud.show_message("SETOR DE PESQUISA — cada loop agora dura 25 minutos.", 4.0)
	get_tree().create_timer(1.3).timeout.connect(NarratorManager.introduce_research_wing)

