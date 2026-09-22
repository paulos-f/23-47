extends Node

signal line_spoken(text: String, mood: StringName)
signal anger_changed(level: int)

var anger_level := 0
var _reactions_played: Dictionary = {}


func _ready() -> void:
	KnowledgeManager.knowledge_added.connect(_on_knowledge_added)


func speak(text: String, mood: StringName = &"calm") -> void:
	line_spoken.emit(text, mood)


func introduce_lobby() -> void:
	if KnowledgeManager.loop_count == 1:
		speak("Bem-vindo à antessala. Faça o que eu digo e isto será simples.", &"calm")
	elif not KnowledgeManager.knows(&"lobby_completed"):
		speak("De volta ao começo. Talvez desta vez você escute minhas instruções.", &"irritated")


func introduce_research_wing() -> void:
	if not KnowledgeManager.knows(&"override_sequence_known"):
		speak("Energize o Laboratório. O Arquivo é uma distração inútil.", &"calm")
	else:
		speak("Você trouxe uma resposta de outro loop. Isso não estava previsto.", &"irritated")


func register_defiance(reason: StringName, line: String) -> void:
	if _reactions_played.has(reason):
		return
	_reactions_played[reason] = true
	anger_level = mini(anger_level + 1, 5)
	anger_changed.emit(anger_level)
	speak(line, &"angry" if anger_level >= 3 else &"irritated")


func clear_for_new_game() -> void:
	anger_level = 0
	_reactions_played.clear()
	anger_changed.emit(anger_level)


func _on_knowledge_added(key: StringName, _value: Variant) -> void:
	match key:
		&"safe_code_discovered":
			speak("Uma senha não é uma vitória. É só uma porta que permiti que existisse.", &"calm")
		&"midnight_origin_discovered":
			register_defiance(&"lobby_solved", "Chega. A antessala deveria ter mantido você ocupado por mais tempo.")
		&"override_sequence_known":
			register_defiance(&"archive_ignored_warning", "Eu disse que o Arquivo era inútil. Você está tornando isto desagradável.")
		&"phase_one_complete":
			register_defiance(&"phase_one_complete", "Você insiste em tratar minhas regras como peças de um quebra-cabeça.")

