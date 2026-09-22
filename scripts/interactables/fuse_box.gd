class_name FuseBox
extends StaticBody3D

@export var required_item: StringName = &"fuse"
@export var unlocked_door_group: StringName = &"archive_door"

@onready var indicator: OmniLight3D = $Indicator
@onready var lever: Node3D = $Lever

var powered := false


func get_interaction_prompt(player: Node) -> String:
	if powered:
		return "[E] Examinar painel energizado"
	var inventory := player.get_node_or_null("Inventory") as PlayerInventory
	if inventory != null and inventory.has_item(required_item):
		return "[E] Instalar fusível"
	return "[E] Examinar quadro elétrico"


func interact(player: Node) -> String:
	if powered:
		return "O circuito marcado ‘ARQUIVO’ está ativo."
	var inventory := player.get_node_or_null("Inventory") as PlayerInventory
	if inventory == null or not inventory.has_item(required_item):
		KnowledgeManager.learn(&"fuse_panel_discovered", true)
		return "Falta um fusível. O circuito controla a porta do arquivo."
	inventory.remove_item(required_item)
	inventory.add_item(&"archive_access")
	powered = true
	KnowledgeManager.learn(&"archive_mechanism_known", true)
	indicator.light_color = Color(0.25, 1.0, 0.48)
	indicator.light_energy = 2.0
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(lever, "rotation:z", deg_to_rad(-55.0), 0.45)
	get_tree().call_group(unlocked_door_group, "force_open")
	GameManager.show_message("A energia percorre a casa. Uma porta pesada se abre.", 3.5)
	return "Circuito restaurado. A sala de arquivo foi desbloqueada."

