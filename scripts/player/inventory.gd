class_name PlayerInventory
extends Node

signal item_added(item_id: StringName)
signal item_removed(item_id: StringName)

var _items: Dictionary = {}


func add_item(item_id: StringName) -> void:
	if _items.has(item_id):
		return
	_items[item_id] = true
	item_added.emit(item_id)


func has_item(item_id: StringName) -> bool:
	return item_id != &"" and _items.has(item_id)


func remove_item(item_id: StringName) -> bool:
	if not _items.erase(item_id):
		return false
	item_removed.emit(item_id)
	return true


func add_key(key_id: StringName) -> void:
	add_item(key_id)


func has_key(key_id: StringName) -> bool:
	return has_item(key_id)


func remove_key(key_id: StringName) -> bool:
	return remove_item(key_id)


func clear() -> void:
	_items.clear()
