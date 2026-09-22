extends Node

signal knowledge_added(key: StringName, value: Variant)
signal loop_count_changed(new_count: int)

var knowledge: Dictionary = {}
var loop_count := 1


func learn(key: StringName, value: Variant = true) -> bool:
	if knowledge.has(key) and knowledge[key] == value:
		return false
	knowledge[key] = value
	knowledge_added.emit(key, value)
	return true


func knows(key: StringName) -> bool:
	return knowledge.get(key, false) == true


func recall(key: StringName, default_value: Variant = null) -> Variant:
	return knowledge.get(key, default_value)


func complete_loop() -> void:
	loop_count += 1
	loop_count_changed.emit(loop_count)


func clear_for_new_game() -> void:
	knowledge.clear()
	loop_count = 1
	loop_count_changed.emit(loop_count)

