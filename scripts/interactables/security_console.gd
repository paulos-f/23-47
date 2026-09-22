class_name SecurityConsole
extends StaticBody3D

@export var required_knowledge: StringName = &"override_sequence_known"
@export var required_item: StringName = &"research_keycard"
@export var unlocked_door_group: StringName = &"observation_door"

@onready var indicator: OmniLight3D = $Indicator

var activated := false


func _ready() -> void:
	if KnowledgeManager.knows(&"observation_door_unlocked"):
		call_deferred("_restore_known_access")


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Acessar controle de observação"


func interact(player: Node) -> String:
	if activated:
		return "A porta da sala de observação está liberada."
	var inventory := player.get_node_or_null("Inventory") as PlayerInventory
	var knows_sequence := KnowledgeManager.knows(required_knowledge)
	var has_card := inventory != null and inventory.has_item(required_item)
	if not knows_sequence and not has_card:
		return "O terminal exige uma sequência de quatro passos e um cartão físico."
	if not knows_sequence:
		return "Cartão aceito, mas falta a sequência. O cartão desaparecerá no próximo loop."
	if not has_card:
		return "Sequência 4-1-3-2 memorizada. Falta o cartão físico do Laboratório."
	inventory.remove_item(required_item)
	inventory.add_item(&"observation_access")
	activated = true
	KnowledgeManager.learn(&"observation_door_unlocked", true)
	indicator.light_color = Color(0.2, 1.0, 0.48)
	indicator.light_energy = 2.4
	get_tree().call_group(unlocked_door_group, "force_open")
	NarratorManager.register_defiance(
		&"combined_loops",
		"Não. Esses recursos nunca estiveram disponíveis ao mesmo tempo. Você não deveria combiná-los."
	)
	return "A sequência e o cartão foram combinados. Sala de observação liberada."


func _restore_known_access() -> void:
	activated = true
	indicator.light_color = Color(0.2, 1.0, 0.48)
	get_tree().call_group(unlocked_door_group, "force_open")

