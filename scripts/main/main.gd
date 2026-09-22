extends Node3D

@onready var player: FirstPersonPlayer = $Player
@onready var hud: GameHUD = $HUD
@onready var objective_tracker: ObjectiveTracker = $ObjectiveTracker


func _ready() -> void:
	player.interaction_prompt_changed.connect(hud.set_interaction_prompt)
	player.message_requested.connect(hud.show_message)
	GameManager.message_requested.connect(hud.show_message)
	NarratorManager.line_spoken.connect(hud.show_narrator)
	NarratorManager.anger_changed.connect(hud.set_narrator_anger)
	TimeManager.minute_changed.connect(hud.set_clock)
	KnowledgeManager.loop_count_changed.connect(hud.set_loop_count)
	objective_tracker.objective_changed.connect(hud.set_objective)
	objective_tracker.setup(player.inventory)

	hud.set_loop_count(KnowledgeManager.loop_count)
	hud.set_narrator_anger(NarratorManager.anger_level)
	TimeManager.configure_loop(23, 47, 0, 0, 5.0)
	TimeManager.start_loop()
	if KnowledgeManager.loop_count == 1:
		hud.show_message("Você desperta às 23:47. Algo nesta casa está prestes a acontecer.", 4.5)
	else:
		hud.show_message("23:47 novamente. Os objetos voltaram; suas lembranças, não.", 4.0)
	get_tree().create_timer(1.2).timeout.connect(NarratorManager.introduce_lobby)
