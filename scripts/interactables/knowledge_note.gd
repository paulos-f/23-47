class_name KnowledgeNote
extends StaticBody3D

@export var knowledge_key: StringName = &"safe_code_discovered"
@export var note_text := "1987"
@export var required_stabilized_route: StringName = &""


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Decodificar documento" if required_stabilized_route != &"" else "[E] Examinar bilhete"


func interact(_player: Node) -> String:
	if required_stabilized_route != &"":
		var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
		if router == null or not router.is_route_stabilized(required_stabilized_route):
			return "O documento está criptografado. Estabilize os dois relés desta ala na ordem correta."
	var is_new := KnowledgeManager.learn(knowledge_key, true)
	if is_new:
		return "O bilhete diz: “%s”. Nova informação descoberta." % note_text
	return "O bilhete diz: “%s”. Você já memorizou isso." % note_text
