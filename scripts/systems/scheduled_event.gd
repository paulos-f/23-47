class_name ScheduledEvent
extends Node

@export_range(0, 23, 1) var trigger_hour := 23
@export_range(0, 59, 1) var trigger_minute := 47
@export var target_group: StringName
@export var method_name: StringName
@export var arguments: Array[Variant] = []
@export var debug_label := "Evento"

var _fired := false


func matches(hour: int, minute: int) -> bool:
	return not _fired and hour == trigger_hour and minute == trigger_minute


func fire() -> void:
	_fired = true
	var target := get_tree().get_first_node_in_group(target_group)
	if target == null:
		push_warning("%s: grupo alvo '%s' não encontrado." % [debug_label, target_group])
		return
	if not target.has_method(method_name):
		push_warning("%s: método '%s' não existe no alvo." % [debug_label, method_name])
		return
	target.callv(method_name, arguments)

