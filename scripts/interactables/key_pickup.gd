class_name KeyPickup
extends StaticBody3D

@export var key_id: StringName = &"office_key"
@export var display_name := "chave do escritório"

var collected := false


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Pegar %s" % display_name


func interact(player: Node) -> String:
	if collected:
		return ""
	var inventory := player.get_node_or_null("Inventory")
	if inventory == null:
		return "Você não consegue guardar a chave."
	collected = true
	inventory.add_key(key_id)
	queue_free()
	return "Chave adquirida."

