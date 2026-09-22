class_name InventoryPickup
extends StaticBody3D

@export var item_id: StringName = &"fuse"
@export var display_name := "fusível de cerâmica"
@export var acquired_message := "Fusível adquirido."

var collected := false


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Pegar %s" % display_name


func interact(player: Node) -> String:
	if collected:
		return ""
	var inventory := player.get_node_or_null("Inventory") as PlayerInventory
	if inventory == null:
		return "Você não consegue guardar o objeto."
	collected = true
	inventory.add_item(item_id)
	queue_free()
	return acquired_message

