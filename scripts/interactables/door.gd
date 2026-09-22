class_name InteractiveDoor
extends Node3D

@export var locked := false
@export var required_key: StringName = &""
@export_range(-170.0, 170.0, 1.0) var open_angle := 95.0
@export_range(0.05, 5.0, 0.05) var animation_duration := 0.65

@onready var hinge: Node3D = $Hinge

var is_open := false
var _tween: Tween


func get_interaction_prompt(player: Node) -> String:
	if locked:
		var inventory := player.get_node_or_null("Inventory")
		if inventory != null and inventory.has_key(required_key):
			return "[E] Usar chave"
		return "[E] Tentar abrir"
	return "[E] Fechar porta" if is_open else "[E] Abrir porta"


func interact(player: Node) -> String:
	if locked:
		var inventory := player.get_node_or_null("Inventory")
		if inventory == null or not inventory.has_key(required_key):
			return "Porta trancada."
		locked = false
		_set_open(true)
		return "A chave destrancou a porta."
	_set_open(not is_open)
	return ""


func force_open() -> void:
	locked = false
	_set_open(true)


func _set_open(value: bool) -> void:
	is_open = value
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var target_rotation := deg_to_rad(open_angle) if is_open else 0.0
	_tween.tween_property(hinge, "rotation:y", target_rotation, animation_duration)

