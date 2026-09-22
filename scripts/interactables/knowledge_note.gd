class_name KnowledgeNote
extends StaticBody3D

@export var knowledge_key: StringName = &"safe_code_discovered"
@export var note_text := "1987"


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Examinar bilhete"


func interact(_player: Node) -> String:
	var is_new := KnowledgeManager.learn(knowledge_key, true)
	if is_new:
		return "O bilhete diz: “%s”. Nova informação descoberta." % note_text
	return "O bilhete diz: “%s”. Você já memorizou isso." % note_text

