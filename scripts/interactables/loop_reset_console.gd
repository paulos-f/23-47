class_name LoopResetConsole
extends StaticBody3D

@onready var indicator: OmniLight3D = $Indicator


func get_interaction_prompt(player: Node) -> String:
	return "[E] Sincronizar próximo loop" if _can_reset(player) else "[E] Examinar sincronizador"


func interact(player: Node) -> String:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router == null or router.selected_route == &"":
		return "O sincronizador exige que uma rota seja escolhida primeiro."
	var inventory := player.get_node_or_null("Inventory") as PlayerInventory
	if KnowledgeManager.knows(&"override_sequence_known") and inventory.has_item(&"research_keycard"):
		return "Você possui tudo que precisa. Use o terminal central em vez de reiniciar."
	if not _can_reset(player):
		return "Conclua a tarefa disponível nesta ala antes de abandonar o loop."
	indicator.light_color = Color(0.25, 0.72, 1.0)
	indicator.light_energy = 2.6
	GameManager.call_deferred("restart_current_loop", "SINCRONIZAÇÃO VOLUNTÁRIA")
	return "Estado mental preservado. Objetos físicos serão descartados."


func _can_reset(player: Node) -> bool:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router == null:
		return false
	if router.selected_route == &"archive":
		return KnowledgeManager.knows(&"override_sequence_known")
	if router.selected_route == &"laboratory":
		var inventory := player.get_node_or_null("Inventory") as PlayerInventory
		return inventory != null and inventory.has_item(&"research_keycard") and not KnowledgeManager.knows(&"override_sequence_known")
	return false

