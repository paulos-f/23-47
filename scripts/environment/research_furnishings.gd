class_name ResearchFurnishings
extends Node3D

const MODELS := {
	"bookcase_closed": preload("res://assets/external/kenney_furniture/bookcaseClosed.glb"),
	"bookcase_wide": preload("res://assets/external/kenney_furniture/bookcaseClosedWide.glb"),
	"bookcase_open": preload("res://assets/external/kenney_furniture/bookcaseOpen.glb"),
	"cabinet": preload("res://assets/external/kenney_furniture/cabinetTelevisionDoors.glb"),
	"box_closed": preload("res://assets/external/kenney_furniture/cardboardBoxClosed.glb"),
	"box_open": preload("res://assets/external/kenney_furniture/cardboardBoxOpen.glb"),
	"chair": preload("res://assets/external/kenney_furniture/chairDesk.glb"),
	"monitor": preload("res://assets/external/kenney_furniture/computerScreen.glb"),
	"desk": preload("res://assets/external/kenney_furniture/desk.glb"),
	"laptop": preload("res://assets/external/kenney_furniture/laptop.glb"),
	"plant_small": preload("res://assets/external/kenney_furniture/plantSmall2.glb"),
	"plant": preload("res://assets/external/kenney_furniture/pottedPlant.glb"),
	"radio": preload("res://assets/external/kenney_furniture/radio.glb"),
	"table": preload("res://assets/external/kenney_furniture/table.glb"),
	"trash": preload("res://assets/external/kenney_furniture/trashcan.glb"),
}


func _ready() -> void:
	_build_atrium()
	_build_archive()
	_build_laboratory()
	_build_observation()


func _build_atrium() -> void:
	_spawn("desk", Vector3(-1.1, 0.12, 9.2), 0.0, 1.25, Vector3(2.3, 1.0, 1.2))
	_spawn("desk", Vector3(1.1, 0.12, 9.2), 0.0, 1.25, Vector3(2.3, 1.0, 1.2))
	_spawn("monitor", Vector3(-1.1, 1.08, 9.2), 0.0, 1.15)
	_spawn("monitor", Vector3(1.1, 1.08, 9.2), 0.0, 1.15)
	_spawn("chair", Vector3(-1.1, 0.12, 10.5), PI, 1.1)
	_spawn("chair", Vector3(1.1, 0.12, 10.5), PI, 1.1)
	_spawn("plant", Vector3(-19.8, 0.12, 13.7), 0.0, 1.3)
	_spawn("plant", Vector3(19.8, 0.12, 13.7), 0.0, 1.3)
	_spawn("trash", Vector3(4.0, 0.12, 8.9), 0.0, 1.0)
	_spawn("radio", Vector3(-3.4, 1.05, 9.15), PI, 0.8)


func _build_archive() -> void:
	for z_position in [-5.8, -2.8, 0.1]:
		_spawn("bookcase_closed", Vector3(-20.4, 0.12, z_position), -PI / 2.0, 1.25, Vector3(0.7, 2.2, 2.0))
	_spawn("bookcase_wide", Vector3(-15.5, 0.12, -7.35), PI, 1.25, Vector3(2.8, 2.1, 0.7))
	_spawn("bookcase_open", Vector3(-11.8, 0.12, -7.35), PI, 1.25, Vector3(2.0, 2.1, 0.7))
	_spawn("table", Vector3(-11.0, 0.12, -3.2), 0.0, 1.45, Vector3(3.2, 1.0, 1.5))
	_spawn("chair", Vector3(-11.0, 0.12, -1.75), PI, 1.05)
	_spawn("box_closed", Vector3(-18.6, 0.12, -6.8), 0.2, 1.1, Vector3(0.9, 0.9, 0.9))
	_spawn("box_open", Vector3(-17.5, 0.12, -6.7), -0.25, 1.1, Vector3(0.9, 0.9, 0.9))


func _build_laboratory() -> void:
	_spawn("table", Vector3(11.0, 0.12, -3.2), 0.0, 1.45, Vector3(3.2, 1.0, 1.5))
	_spawn("desk", Vector3(17.5, 0.12, -6.4), PI / 2.0, 1.25, Vector3(1.2, 1.0, 2.3))
	_spawn("desk", Vector3(20.2, 0.12, -2.6), -PI / 2.0, 1.25, Vector3(1.2, 1.0, 2.3))
	_spawn("laptop", Vector3(11.0, 1.05, -3.2), PI, 1.1)
	_spawn("monitor", Vector3(17.2, 1.08, -6.4), -PI / 2.0, 1.15)
	_spawn("monitor", Vector3(19.9, 1.08, -2.6), PI / 2.0, 1.15)
	_spawn("cabinet", Vector3(15.0, 0.12, -7.35), PI, 1.25, Vector3(2.0, 1.5, 0.7))
	_spawn("plant_small", Vector3(8.2, 0.12, -6.8), 0.0, 1.15)
	_spawn("plant_small", Vector3(19.3, 0.12, 0.2), 0.0, 1.15)


func _build_observation() -> void:
	_spawn("desk", Vector3(0, 0.12, -12.0), PI, 1.45, Vector3(2.8, 1.0, 1.35))
	_spawn("monitor", Vector3(-0.6, 1.08, -12.0), PI, 1.2)
	_spawn("laptop", Vector3(0.65, 1.05, -12.0), PI, 1.0)
	_spawn("chair", Vector3(0, 0.12, -10.5), 0.0, 1.1)
	_spawn("bookcase_wide", Vector3(-7.0, 0.12, -15.35), PI, 1.25, Vector3(2.8, 2.1, 0.7))
	_spawn("bookcase_wide", Vector3(7.0, 0.12, -15.35), PI, 1.25, Vector3(2.8, 2.1, 0.7))
	_spawn("plant", Vector3(-19.8, 0.12, -14.0), 0.0, 1.25)
	_spawn("plant", Vector3(19.8, 0.12, -14.0), 0.0, 1.25)


func _spawn(model_id: String, position_value: Vector3, yaw: float, uniform_scale: float, collider_size := Vector3.ZERO) -> void:
	var packed := MODELS[model_id] as PackedScene
	var instance := packed.instantiate() as Node3D
	instance.name = "%s_%d" % [model_id, get_child_count()]
	instance.position = position_value
	instance.rotation.y = yaw
	instance.scale = Vector3.ONE * uniform_scale
	add_child(instance)
	if collider_size == Vector3.ZERO:
		return
	var body := StaticBody3D.new()
	body.name = "%sCollision" % instance.name
	body.position = position_value + Vector3(0, collider_size.y * 0.5, 0)
	body.rotation.y = yaw
	body.collision_layer = 1
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = collider_size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

