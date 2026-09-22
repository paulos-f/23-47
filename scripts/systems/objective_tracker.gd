class_name ObjectiveTracker
extends Node

signal objective_changed(text: String)

var _inventory: PlayerInventory


func _ready() -> void:
	KnowledgeManager.knowledge_added.connect(_on_knowledge_added)


func setup(inventory: PlayerInventory) -> void:
	_inventory = inventory
	if not _inventory.item_added.is_connected(_on_item_added):
		_inventory.item_added.connect(_on_item_added)
	_refresh()


func _refresh() -> void:
	if KnowledgeManager.knows(&"midnight_origin_discovered"):
		objective_changed.emit("Capítulo concluído: você descobriu de onde vem o evento da meia-noite.")
	elif _inventory != null and _inventory.has_item(&"archive_access"):
		objective_changed.emit("Objetivo: entre na sala de arquivo e examine o dossiê.")
	elif _inventory != null and _inventory.has_item(&"fuse"):
		objective_changed.emit("Objetivo: instale o fusível no quadro elétrico do corredor.")
	elif KnowledgeManager.knows(&"safe_code_discovered"):
		objective_changed.emit("Objetivo: use 1987 no cofre da sala e recupere o fusível.")
	elif _inventory != null and _inventory.has_key(&"office_key"):
		objective_changed.emit("Objetivo: abra o escritório e procure pistas.")
	else:
		objective_changed.emit("Objetivo: às 23:51, pegue a chave deixada na cozinha.")


func _on_item_added(_item_id: StringName) -> void:
	_refresh()


func _on_knowledge_added(_key: StringName, _value: Variant) -> void:
	_refresh()
