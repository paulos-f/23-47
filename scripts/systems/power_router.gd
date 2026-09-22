class_name PowerRouter
extends Node

signal route_selected(route_id: StringName)

@export var keycard_scene: PackedScene

var selected_route: StringName = &""


func choose_route(route_id: StringName) -> String:
	if selected_route != &"":
		return "A distribuição já está travada em %s neste loop." % _route_name(selected_route)
	if route_id != &"archive" and route_id != &"laboratory":
		return "Rota de energia desconhecida."
	selected_route = route_id
	if route_id == &"archive":
		get_tree().call_group("phase_archive_door", "force_open")
		KnowledgeManager.learn(&"archive_route_discovered", true)
		NarratorManager.register_defiance(
			&"chose_archive",
			"Eu recomendei o Laboratório. Sua desobediência vai custar tempo."
		)
	else:
		get_tree().call_group("phase_lab_door", "force_open")
		KnowledgeManager.learn(&"laboratory_route_discovered", true)
		_spawn_keycard()
		NarratorManager.speak("Boa escolha. Pegue o cartão e ignore o Arquivo.", &"calm")
	route_selected.emit(selected_route)
	return "Energia direcionada para %s. A outra ala ficará isolada até o próximo loop." % _route_name(selected_route)


func _spawn_keycard() -> void:
	if keycard_scene == null:
		push_warning("PowerRouter não possui cena de cartão configurada.")
		return
	var spawn := get_tree().get_first_node_in_group("phase_keycard_spawn") as Node3D
	if spawn == null:
		push_warning("Ponto do cartão de pesquisa não encontrado.")
		return
	var keycard := keycard_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(keycard)
	keycard.global_transform = spawn.global_transform


func _route_name(route_id: StringName) -> String:
	return "ARQUIVO" if route_id == &"archive" else "LABORATÓRIO"

