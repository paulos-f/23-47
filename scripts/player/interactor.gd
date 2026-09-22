class_name PlayerInteractor
extends Node

signal prompt_changed(text: String)
signal interaction_finished(message: String)

@export var raycast_path: NodePath

var _raycast: RayCast3D
var _current_target: Node
var _last_prompt := ""


func _ready() -> void:
	_raycast = get_node_or_null(raycast_path) as RayCast3D
	if _raycast == null:
		push_error("PlayerInteractor precisa de um RayCast3D válido.")
		set_process(false)


func _process(_delta: float) -> void:
	_current_target = _find_interactable()
	var next_prompt := ""
	if _current_target != null:
		next_prompt = str(_current_target.call("get_interaction_prompt", get_parent()))
	if next_prompt != _last_prompt:
		_last_prompt = next_prompt
		prompt_changed.emit(next_prompt)


func try_interact() -> void:
	_current_target = _find_interactable()
	if _current_target == null:
		return
	var result: Variant = _current_target.call("interact", get_parent())
	if result is String and not result.is_empty():
		interaction_finished.emit(result)


func _find_interactable() -> Node:
	if _raycast == null or not _raycast.is_colliding():
		return null
	var candidate := _raycast.get_collider() as Node
	while candidate != null:
		if candidate.has_method("interact") and candidate.has_method("get_interaction_prompt"):
			return candidate
		candidate = candidate.get_parent()
	return null

