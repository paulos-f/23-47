class_name GameHUD
extends CanvasLayer

@onready var clock_label: Label = $Interface/ClockPanel/Clock
@onready var loop_label: Label = $Interface/ClockPanel/Loop
@onready var interaction_label: Label = $Interface/InteractionPrompt
@onready var message_label: Label = $Interface/Message
@onready var objective_label: Label = $Interface/Objective
@onready var transition_rect: ColorRect = $Transition
@onready var transition_label: Label = $Transition/CenterText
@onready var narrator_panel: PanelContainer = $Interface/NarratorPanel
@onready var narrator_label: Label = $Interface/NarratorPanel/Text
@onready var operator_status: Label = $Interface/OperatorStatus

var _message_generation := 0
var _narrator_generation := 0


func set_clock(_hour: int, _minute: int, display_time: String) -> void:
	clock_label.text = display_time


func set_loop_count(count: int) -> void:
	loop_label.text = "LOOP %d" % count


func set_narrator_anger(level: int) -> void:
	operator_status.text = "OPERADOR // PRESSÃO %d/5" % level
	operator_status.modulate = Color(1.0, 0.48, 0.35) if level >= 3 else Color(0.55, 0.66, 0.76)


func set_interaction_prompt(text: String) -> void:
	interaction_label.text = text


func set_objective(text: String) -> void:
	objective_label.text = text


func show_message(text: String, duration := 2.5) -> void:
	_message_generation += 1
	var generation := _message_generation
	message_label.text = text
	message_label.modulate.a = 1.0
	await get_tree().create_timer(duration).timeout
	if generation != _message_generation:
		return
	var tween := create_tween()
	tween.tween_property(message_label, "modulate:a", 0.0, 0.45)


func show_narrator(text: String, mood: StringName = &"calm") -> void:
	_narrator_generation += 1
	var generation := _narrator_generation
	narrator_label.text = text
	narrator_label.modulate = Color(1.0, 0.76, 0.55) if mood == &"angry" else Color(0.76, 0.84, 0.94)
	narrator_panel.visible = true
	narrator_panel.modulate.a = 0.0
	var fade_in := create_tween()
	fade_in.tween_property(narrator_panel, "modulate:a", 1.0, 0.3)
	await get_tree().create_timer(4.8).timeout
	if generation != _narrator_generation:
		return
	var fade_out := create_tween()
	fade_out.tween_property(narrator_panel, "modulate:a", 0.0, 0.5)
	await fade_out.finished
	if generation == _narrator_generation:
		narrator_panel.visible = false


func play_loop_transition(next_loop: int) -> void:
	transition_rect.visible = true
	transition_rect.modulate.a = 0.0
	transition_label.text = "00:00"
	var fade := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade.tween_property(transition_rect, "modulate:a", 1.0, 1.0)
	await fade.finished
	await get_tree().create_timer(0.85).timeout
	transition_label.text = "LOOP %d" % next_loop
	await get_tree().create_timer(1.0).timeout


func play_level_transition(title: String) -> void:
	transition_rect.visible = true
	transition_rect.modulate.a = 0.0
	transition_label.text = title
	var fade := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade.tween_property(transition_rect, "modulate:a", 1.0, 0.8)
	await fade.finished
	await get_tree().create_timer(0.75).timeout
