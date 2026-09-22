extends Control

@onready var stats_label: Label = $Center/Stats
@onready var operator_label: Label = $Center/Operator


func _ready() -> void:
	TimeManager.pause()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	stats_label.text = "CAPÍTULO CONCLUÍDO EM %d LOOPS\nPRESSÃO DO OPERADOR: %d/5" % [KnowledgeManager.loop_count, NarratorManager.anger_level]
	operator_label.text = "“Isto era apenas o primeiro teste.\nNa próxima vez, as regras não serão tão generosas.”"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		KnowledgeManager.clear_for_new_game()
		NarratorManager.clear_for_new_game()
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")

