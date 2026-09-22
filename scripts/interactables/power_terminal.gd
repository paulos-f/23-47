class_name PowerTerminal
extends StaticBody3D

@export_enum("archive", "laboratory") var route_id := "archive"
@export var display_name := "ARQUIVO"
@export var indicator_color := Color(1.0, 0.55, 0.2)

@onready var indicator: OmniLight3D = $Indicator
@onready var route_label: Label3D = $RouteLabel


func _ready() -> void:
	indicator.light_color = indicator_color
	route_label.text = display_name


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Direcionar energia: %s" % display_name


func interact(_player: Node) -> String:
	var router := get_tree().get_first_node_in_group("power_router") as PowerRouter
	if router == null:
		return "O distribuidor central não responde."
	var result := router.choose_route(StringName(route_id))
	if router.selected_route == StringName(route_id):
		indicator.light_energy = 2.8
	return result
