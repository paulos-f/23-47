class_name PowerRouter
extends Node

signal route_selected(route_id: StringName)
signal relay_progress_changed(route_id: StringName, completed: int, required: int)
signal route_stabilized(route_id: StringName)

@export var keycard_scene: PackedScene

const REQUIRED_RELAYS := 2

var selected_route: StringName = &""
var _next_relay_index := 0
var _stabilized := false


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
		NarratorManager.speak("Boa escolha. Estabilize os relés e ignore o Arquivo.", &"calm")
	route_selected.emit(selected_route)
	relay_progress_changed.emit(selected_route, 0, REQUIRED_RELAYS)
	return "Energia em %s. Estabilize os relés 1 e 2; a outra ala ficará isolada neste loop." % _route_name(selected_route)


func activate_relay(route_id: StringName, relay_index: int) -> String:
	if selected_route == &"":
		return "Escolha primeiro uma rota no distribuidor central."
	if route_id != selected_route:
		return "Este relé não recebe energia no loop atual."
	if _stabilized:
		return "A rota %s já está estável." % _route_name(route_id)
	if relay_index != _next_relay_index:
		_next_relay_index = 0
		get_tree().call_group("route_relays", "sync_from_router")
		relay_progress_changed.emit(selected_route, 0, REQUIRED_RELAYS)
		NarratorManager.speak("Ordem incorreta. Toda a calibração foi descartada.", &"irritated")
		return "Sequência incorreta. Os relés voltaram ao estado inicial."
	_next_relay_index += 1
	get_tree().call_group("route_relays", "sync_from_router")
	relay_progress_changed.emit(selected_route, _next_relay_index, REQUIRED_RELAYS)
	if _next_relay_index < REQUIRED_RELAYS:
		return "Relé 1 confirmado. Agora encontre e ative o relé 2."
	_stabilized = true
	get_tree().call_group("route_relays", "sync_from_router")
	KnowledgeManager.learn(StringName("%s_stabilized_once" % route_id), true)
	if selected_route == &"laboratory":
		_spawn_keycard()
	else:
		NarratorManager.speak("A criptografia do Arquivo foi removida.", &"irritated")
	route_stabilized.emit(selected_route)
	return "Rota %s estabilizada. A recompensa desta ala está disponível." % _route_name(route_id)


func is_route_stabilized(route_id: StringName) -> bool:
	return _stabilized and selected_route == route_id


func get_relay_progress() -> int:
	return _next_relay_index


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
