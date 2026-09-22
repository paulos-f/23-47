extends Node3D

@onready var player: FirstPersonPlayer = $Player
@onready var hud: GameHUD = $HUD
@onready var power_router: PowerRouter = $PowerRouter
@onready var objective_tracker: ResearchObjectiveTracker = $ObjectiveTracker


func _ready() -> void:
	player.interaction_prompt_changed.connect(hud.set_interaction_prompt)
	player.message_requested.connect(hud.show_message)
	GameManager.message_requested.connect(hud.show_message)
	NarratorManager.line_spoken.connect(hud.show_narrator)
	NarratorManager.anger_changed.connect(hud.set_narrator_anger)
	TimeManager.minute_changed.connect(hud.set_clock)
	KnowledgeManager.loop_count_changed.connect(hud.set_loop_count)
	objective_tracker.objective_changed.connect(hud.set_objective)
	objective_tracker.setup(player.inventory, power_router)
	hud.set_loop_count(KnowledgeManager.loop_count)
	hud.set_narrator_anger(NarratorManager.anger_level)
	var loop_settings := NarratorManager.get_research_loop_settings()
	TimeManager.configure_loop(23, loop_settings.start_minute, 0, 0, loop_settings.seconds_per_minute)
	TimeManager.start_loop()
	var available_minutes: int = 60 - int(loop_settings.start_minute)
	hud.show_message("SETOR DE PESQUISA — %d minutos disponíveis neste loop." % available_minutes, 4.0)
	get_tree().create_timer(1.3).timeout.connect(NarratorManager.introduce_research_wing)
