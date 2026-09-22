class_name ResearchEvents
extends Node


func midpoint_warning() -> void:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router != null and router.selected_route == &"":
		NarratorManager.speak("Dez minutos e nenhuma decisão. Indecisão também produz consequências.", &"irritated")


func final_warning() -> void:
	if KnowledgeManager.knows(&"phase_one_complete"):
		return
	NarratorManager.speak("Cinco minutos. Quando o relógio zerar, seu cartão e suas certezas desaparecem.", &"angry")

