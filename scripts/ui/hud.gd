class_name GameHUD
extends CanvasLayer

@onready var clock_label: Label = $Interface/ClockPanel/Clock
@onready var loop_label: Label = $Interface/ClockPanel/Loop
@onready var interaction_label: Label = $Interface/InteractionPrompt
@onready var message_label: Label = $Interface/Message
@onready var objective_label: Label = $Interface/Objective
@onready var transition_rect: ColorRect = $Transition
@onready var transition_label: Label = $Transition/CenterText

var _message_generation := 0


func set_clock(_hour: int, _minute: int, display_time: String) -> void:
	clock_label.text = display_time


func set_loop_count(count: int) -> void:
	loop_label.text = "LOOP %d" % count


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

