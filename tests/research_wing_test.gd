extends Node

var _knowledge: Node
var _narrator: Node


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_knowledge = get_tree().root.get_node("KnowledgeManager")
	_narrator = get_tree().root.get_node("NarratorManager")
	_knowledge.clear_for_new_game()
	_narrator.clear_for_new_game()

	# Loop 1: o jogador desobedece ao narrador e escolhe conhecimento permanente.
	var first_loop := await _spawn_phase()
	var first_router := first_loop.get_node("PowerRouter") as PowerRouter
	var archive_door := first_loop.get_node("ArchiveDoor") as InteractiveDoor
	first_router.choose_route(&"archive")
	if not _check(archive_door.is_open, "A rota do Arquivo não abriu sua porta."):
		return
	first_loop.get_node("ArchiveSequence").interact(first_loop.get_node("Player"))
	if not _check(_knowledge.knows(&"override_sequence_known"), "A sequência não virou conhecimento persistente."):
		return
	await _discard_phase(first_loop)

	# Loop 2: o item físico passa a ser útil porque a sequência já é conhecida.
	var second_loop := await _spawn_phase()
	var player := second_loop.get_node("Player") as FirstPersonPlayer
	var second_router := second_loop.get_node("PowerRouter") as PowerRouter
	second_router.choose_route(&"laboratory")
	await get_tree().process_frame
	var keycard := get_tree().get_first_node_in_group("research_keycard") as InventoryPickup
	if not _check(keycard != null, "A rota do Laboratório não disponibilizou o cartão."):
		return
	keycard.interact(player)
	await get_tree().process_frame
	if not _check(player.inventory.has_item(&"research_keycard"), "O cartão não entrou no inventário."):
		return
	var console := second_loop.get_node("SecurityConsole") as SecurityConsole
	var observation_door := second_loop.get_node("ObservationDoor") as InteractiveDoor
	console.interact(player)
	if not _check(console.activated and observation_door.is_open, "Conhecimento e cartão não abriram a Observação."):
		return
	second_loop.get_node("ObservationReport").interact(player)
	if not _check(_knowledge.knows(&"phase_one_complete"), "O relatório final não concluiu a fase."):
		return
	if not _check(TimeManager.loop_start_minute >= 23 * 60 + 37 and TimeManager.seconds_per_game_minute < 7.0, "O narrador não dificultou o loop após ser contrariado."):
		return

	await _discard_phase(second_loop)
	print("RESEARCH_WING_TEST: PASS")
	get_tree().quit(0)


func _spawn_phase() -> Node:
	var packed := load("res://scenes/main/research_wing.tscn") as PackedScene
	var scene := packed.instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	await get_tree().process_frame
	await get_tree().process_frame
	return scene


func _discard_phase(scene: Node) -> void:
	var music := scene.get_node_or_null("AmbientMusic")
	if music != null:
		music.call("shutdown")
	await get_tree().process_frame
	scene.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame


func _check(condition: bool, failure_message: String) -> bool:
	if condition:
		return true
	push_error("RESEARCH_WING_TEST: %s" % failure_message)
	get_tree().quit(1)
	return false
