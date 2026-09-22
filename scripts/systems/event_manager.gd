class_name TimelineEventManager
extends Node

signal event_fired(event_label: String)


func _ready() -> void:
	TimeManager.time_reached.connect(_on_time_reached)


func _on_time_reached(hour: int, minute: int) -> void:
	for child in get_children():
		if child.has_method("matches") and child.call("matches", hour, minute):
			child.call("fire")
			event_fired.emit(child.debug_label)

