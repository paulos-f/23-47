extends Node3D

@onready var player: FirstPersonPlayer = $Player
@onready var hud: GameHUD = $HUD
@onready var objective_tracker: ObjectiveTracker = $ObjectiveTracker


func _ready() -> void:
	player.interaction_prompt_changed.connect(hud.set_interaction_prompt)
	player.message_requested.connect(hud.show_message)
	GameManager.message_requested.connect(hud.show_message)
	TimeManager.minute_changed.connect(hud.set_clock)
	KnowledgeManager.loop_count_changed.connect(hud.set_loop_count)
	objective_tracker.objective_changed.connect(hud.set_objective)
	objective_tracker.setup(player.inventory)

	hud.set_loop_count(KnowledgeManager.loop_count)
	TimeManager.start_loop()
	if KnowledgeManager.loop_count == 1:
		hud.show_message("Você desperta às 23:47. Algo nesta casa está prestes a acontecer.", 4.5)
	else:
		hud.show_message("23:47 novamente. Os objetos voltaram; suas lembranças, não.", 4.0)

