class_name LevelGate
extends StaticBody3D

@export var required_knowledge: StringName = &"midnight_origin_discovered"
@export_file("*.tscn") var next_scene_path := "res://scenes/main/research_wing.tscn"
@export var transition_title := "SETOR DE PESQUISA"
@export var completion_knowledge: StringName = &"lobby_completed"

@onready var status_light: OmniLight3D = $StatusLight


func _ready() -> void:
	_refresh_status()
	KnowledgeManager.knowledge_added.connect(_on_knowledge_added)


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Entrar no elevador" if KnowledgeManager.knows(required_knowledge) else "[E] Examinar elevador"


func interact(_player: Node) -> String:
	if not KnowledgeManager.knows(required_knowledge):
		return "ACESSO NEGADO — conclua o protocolo da antessala."
	if completion_knowledge != &"":
		KnowledgeManager.learn(completion_knowledge, true)
	GameManager.call_deferred("change_level", next_scene_path, transition_title)
	return "Acesso concedido. Descendo para o setor principal..."


func _refresh_status() -> void:
	var unlocked := KnowledgeManager.knows(required_knowledge)
	status_light.light_color = Color(0.2, 1.0, 0.45) if unlocked else Color(1.0, 0.12, 0.06)


func _on_knowledge_added(key: StringName, _value: Variant) -> void:
	if key == required_knowledge:
		_refresh_status()
