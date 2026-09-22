extends Node


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var knowledge_manager := get_tree().root.get_node_or_null("KnowledgeManager")
	var time_manager := get_tree().root.get_node_or_null("TimeManager")
	if not _check(knowledge_manager != null and time_manager != null, "Os AutoLoads não foram inicializados."):
		return
	knowledge_manager.clear_for_new_game()
	var packed_scene := load("res://scenes/main/main.tscn") as PackedScene
	if not _check(packed_scene != null, "A cena principal não pôde ser carregada."):
		return
	var scene := packed_scene.instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	await get_tree().process_frame
	await get_tree().process_frame

	var player := scene.get_node("Player") as FirstPersonPlayer
	var npc := scene.get_node("NPC") as TemporalNPC
	var office_door := scene.get_node("OfficeDoor") as InteractiveDoor
	var note := scene.get_node("KnowledgeNote") as KnowledgeNote
	var safe := scene.get_node("Safe") as KnowledgeSafe
	var fuse_box := scene.get_node("FuseBox") as FuseBox
	var archive_door := scene.get_node("ArchiveDoor") as InteractiveDoor
	var archive_dossier := scene.get_node("ArchiveDossier") as KnowledgeNote
	if not _check(player != null and npc != null and office_door != null and note != null and safe != null and fuse_box != null and archive_door != null and archive_dossier != null, "Nós essenciais ausentes."):
		return

	# Avança pela agenda real até 23:51; o ScheduledEvent deve mandar o NPC soltar a chave.
	for _minute in range(4):
		time_manager.call("_advance_minute")
	await get_tree().process_frame
	var key := get_tree().get_first_node_in_group("collectible_key") as KeyPickup
	if not _check(key != null, "O evento do NPC não criou a chave."):
		return
	key.interact(player)
	await get_tree().process_frame
	if not _check(player.inventory.has_key(&"office_key"), "A chave não entrou no inventário."):
		return
	time_manager.call("_advance_minute")
	var hall_door := scene.get_node("HallDoor") as InteractiveDoor
	if not _check(hall_door != null and hall_door.is_open, "O evento de 23:52 não abriu a porta do corredor."):
		return

	office_door.interact(player)
	if not _check(not office_door.locked and office_door.is_open, "A chave não abriu a porta do escritório."):
		return
	note.interact(player)
	if not _check(knowledge_manager.knows(&"safe_code_discovered"), "O bilhete não registrou conhecimento."):
		return
	safe.interact(player)
	if not _check(safe.opened, "O conhecimento não abriu o cofre."):
		return
	var fuse := get_tree().get_first_node_in_group("safe_reward") as InventoryPickup
	if not _check(fuse != null, "O cofre não entregou o fusível."):
		return
	fuse.interact(player)
	await get_tree().process_frame
	if not _check(player.inventory.has_item(&"fuse"), "O fusível não entrou no inventário."):
		return
	fuse_box.interact(player)
	if not _check(fuse_box.powered and archive_door.is_open and player.inventory.has_item(&"archive_access"), "O quadro não desbloqueou a sala de arquivo."):
		return
	archive_dossier.interact(player)
	if not _check(knowledge_manager.knows(&"midnight_origin_discovered"), "O dossiê final não registrou a descoberta."):
		return

	time_manager.current_total_minutes = 23 * 60 + 59
	time_manager.seconds_per_game_minute = 0.01
	time_manager.time_scale = 100.0
	var deadline := Time.get_ticks_msec() + 7000
	while knowledge_manager.loop_count < 2 and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	if not _check(knowledge_manager.loop_count == 2, "O evento de 00:00 não concluiu o loop."):
		return
	await get_tree().process_frame
	await get_tree().process_frame
	if not _check(knowledge_manager.knows(&"safe_code_discovered"), "O conhecimento foi perdido após o loop."):
		return
	if not _check(knowledge_manager.knows(&"midnight_origin_discovered"), "A descoberta do arquivo foi perdida após o loop."):
		return
	var fresh_inventory := get_tree().current_scene.get_node("Player/Inventory") as PlayerInventory
	if not _check(fresh_inventory != null and not fresh_inventory.has_key(&"office_key"), "O inventário não foi limpo após o loop."):
		return

	var active_music := get_tree().current_scene.get_node_or_null("AmbientMusic") as AudioStreamPlayer
	if active_music != null:
		active_music.call("shutdown")
	await get_tree().create_timer(0.12).timeout
	get_tree().current_scene.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	print("LOOP_2347_SMOKE_TEST: PASS")
	get_tree().quit(0)


func _check(condition: bool, failure_message: String) -> bool:
	if condition:
		return true
	push_error("LOOP_2347_SMOKE_TEST: %s" % failure_message)
	get_tree().quit(1)
	return false
