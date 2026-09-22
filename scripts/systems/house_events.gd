class_name HouseEvents
extends Node

var _flickering := false


func phone_ring() -> void:
	GameManager.show_message("O telefone toca na sala. Ninguém atende.", 3.0)


func start_light_flicker() -> void:
	if _flickering:
		return
	_flickering = true
	GameManager.show_message("As luzes começam a piscar.", 2.5)
	for cycle in range(5):
		get_tree().call_group("house_lights", "set_visible", false)
		await get_tree().create_timer(0.11 if cycle % 2 == 0 else 0.2).timeout
		get_tree().call_group("house_lights", "set_visible", true)
		await get_tree().create_timer(0.16).timeout
	_flickering = false


func power_down() -> void:
	for light in get_tree().get_nodes_in_group("house_lights"):
		if light is Light3D:
			light.light_energy *= 0.22
	GameManager.show_message("A energia cai. Um som distante ecoa no andar superior.", 4.0)

