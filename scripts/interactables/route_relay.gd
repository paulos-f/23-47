class_name RouteRelay
extends StaticBody3D

@export_enum("archive", "laboratory") var route_id := "archive"
@export_range(0, 1, 1) var relay_index := 0
@export var relay_color := Color(1.0, 0.52, 0.18)

@onready var indicator: OmniLight3D = $Indicator
@onready var relay_label: Label3D = $RelayLabel

var activated := false


func _ready() -> void:
	indicator.light_color = relay_color
	relay_label.text = "RELÉ %d" % (relay_index + 1)


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Ativar relé %d" % (relay_index + 1)


func interact(_player: Node) -> String:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router == null:
		return "O relé não encontra o distribuidor central."
	var result := router.activate_relay(StringName(route_id), relay_index)
	activated = router.get_relay_progress() > relay_index or router.is_route_stabilized(StringName(route_id))
	indicator.light_energy = 2.5 if activated else 0.7
	return result


func sync_from_router() -> void:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router == null or router.selected_route != StringName(route_id):
		activated = false
	else:
		activated = router.get_relay_progress() > relay_index or router.is_route_stabilized(StringName(route_id))
	indicator.light_energy = 2.5 if activated else 0.7
