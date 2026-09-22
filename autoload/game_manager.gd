extends Node

signal message_requested(text: String, duration: float)
signal loop_transition_started

var _transitioning := false


func _ready() -> void:
	TimeManager.loop_finished.connect(_on_loop_finished)


func show_message(text: String, duration := 2.5) -> void:
	message_requested.emit(text, duration)


func _on_loop_finished() -> void:
	if _transitioning:
		return
	_transitioning = true
	loop_transition_started.emit()
	get_tree().call_group("player", "set_controls_enabled", false)

	var transition_ui := get_tree().get_first_node_in_group("loop_transition_ui")
	if transition_ui != null and transition_ui.has_method("play_loop_transition"):
		await transition_ui.play_loop_transition(KnowledgeManager.loop_count + 1)
	else:
		await get_tree().create_timer(2.0).timeout

	KnowledgeManager.complete_loop()
	var reload_error := get_tree().reload_current_scene()
	if reload_error != OK:
		push_error("Falha ao reiniciar a cena: %s" % error_string(reload_error))
		_transitioning = false
	else:
		_transitioning = false
