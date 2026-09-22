class_name ResearchObjectiveTracker
extends Node

signal objective_changed(text: String)

var _inventory: PlayerInventory
var _router: PowerRouter


func setup(inventory: PlayerInventory, router: PowerRouter) -> void:
	_inventory = inventory
	_router = router
	_inventory.item_added.connect(_on_state_changed)
	_inventory.item_removed.connect(_on_state_changed)
	_router.route_selected.connect(_on_route_selected)
	_router.relay_progress_changed.connect(_on_relay_progress)
	_router.route_stabilized.connect(_on_route_selected)
	KnowledgeManager.knowledge_added.connect(_on_knowledge_added)
	_refresh()


func _refresh() -> void:
	if KnowledgeManager.knows(&"phase_one_complete"):
		objective_changed.emit("Objetivo: use o elevador da Observação para concluir o capítulo.")
	elif KnowledgeManager.knows(&"observation_door_unlocked") or _inventory.has_item(&"observation_access"):
		objective_changed.emit("Objetivo: entre na sala de observação e examine o relatório central.")
	elif _inventory.has_item(&"research_keycard") and KnowledgeManager.knows(&"override_sequence_known"):
		objective_changed.emit("Objetivo: combine o cartão e a sequência no terminal central.")
	elif _router.selected_route != &"" and not _router.is_route_stabilized(_router.selected_route):
		objective_changed.emit("Objetivo: estabilize os relés na ordem 1 → 2 (%d/2)." % _router.get_relay_progress())
	elif _router.selected_route == &"archive":
		objective_changed.emit("Objetivo: procure no Arquivo a sequência que sobreviverá ao loop.")
	elif _router.selected_route == &"laboratory":
		if KnowledgeManager.knows(&"override_sequence_known"):
			objective_changed.emit("Objetivo: pegue o cartão físico no Laboratório.")
		else:
			objective_changed.emit("O cartão será perdido às 00:00. Talvez a ordem das escolhas importe.")
	elif KnowledgeManager.knows(&"override_sequence_known"):
		objective_changed.emit("Objetivo: neste loop, energize o Laboratório e obtenha o cartão.")
	elif KnowledgeManager.knows(&"research_keycard_seen"):
		objective_changed.emit("Objetivo: o cartão sozinho não basta; energize o Arquivo neste loop.")
	else:
		objective_changed.emit("Objetivo: escolha uma ala. Apenas uma pode receber energia por loop.")


func _on_state_changed(_item_id: StringName) -> void:
	_refresh()


func _on_route_selected(_route_id: StringName) -> void:
	_refresh()


func _on_relay_progress(_route_id: StringName, _completed: int, _required: int) -> void:
	_refresh()


func _on_knowledge_added(_key: StringName, _value: Variant) -> void:
	_refresh()
