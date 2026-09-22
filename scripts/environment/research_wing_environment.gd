class_name ResearchWingEnvironment
extends Node3D

const WALL_HEIGHT := 3.4

var _materials: Dictionary = {}


func _ready() -> void:
	_build_environment()
	_build_architecture()
	_build_landmarks()
	_build_lighting()


func _build_environment() -> void:
	var world := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.008, 0.015, 0.025)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.16, 0.22, 0.3)
	environment.ambient_light_energy = 0.78
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 1.18
	world.environment = environment
	add_child(world)


func _build_architecture() -> void:
	var floor_color := Color(0.075, 0.085, 0.09)
	var wall_color := Color(0.17, 0.19, 0.2)
	_create_box("Floor", Vector3.ZERO, Vector3(44, 0.22, 32), floor_color)
	_create_box("Ceiling", Vector3(0, WALL_HEIGHT, 0), Vector3(44, 0.2, 32), Color(0.055, 0.065, 0.075), false)
	_create_box("NorthWall", Vector3(0, WALL_HEIGHT / 2.0, -16), Vector3(44, WALL_HEIGHT, 0.3), wall_color)
	_create_box("SouthWall", Vector3(0, WALL_HEIGHT / 2.0, 16), Vector3(44, WALL_HEIGHT, 0.3), wall_color)
	_create_box("WestWall", Vector3(-22, WALL_HEIGHT / 2.0, 0), Vector3(0.3, WALL_HEIGHT, 32), wall_color)
	_create_box("EastWall", Vector3(22, WALL_HEIGHT / 2.0, 0), Vector3(0.3, WALL_HEIGHT, 32), wall_color)

	# Duas alas grandes, ambas visíveis a partir do átrio central.
	_create_box("WingWallLeft", Vector3(-16.5, WALL_HEIGHT / 2.0, 2), Vector3(11, WALL_HEIGHT, 0.24), wall_color)
	_create_box("WingWallCenter", Vector3(0, WALL_HEIGHT / 2.0, 2), Vector3(12, WALL_HEIGHT, 0.24), wall_color)
	_create_box("WingWallRight", Vector3(16.5, WALL_HEIGHT / 2.0, 2), Vector3(11, WALL_HEIGHT, 0.24), wall_color)
	_create_box("RearWallLeft", Vector3(-11.5, WALL_HEIGHT / 2.0, -8), Vector3(21, WALL_HEIGHT, 0.24), wall_color)
	_create_box("RearWallRight", Vector3(11.5, WALL_HEIGHT / 2.0, -8), Vector3(21, WALL_HEIGHT, 0.24), wall_color)
	_create_box("CentralDivider", Vector3(0, WALL_HEIGHT / 2.0, -3), Vector3(0.24, WALL_HEIGHT, 10), wall_color)


func _build_landmarks() -> void:
	_create_box("Reception", Vector3(0, 0.62, 9.2), Vector3(6.5, 1.24, 1.2), Color(0.09, 0.12, 0.13))
	_create_box("ArchiveIsland", Vector3(-11, 0.52, -3.2), Vector3(5.5, 1.04, 1.3), Color(0.12, 0.075, 0.04))
	_create_box("LabIsland", Vector3(11, 0.52, -3.2), Vector3(5.5, 1.04, 1.3), Color(0.075, 0.12, 0.12))
	_create_box("ControlPlinth", Vector3(0, 0.55, 5.2), Vector3(5.4, 1.1, 1.1), Color(0.08, 0.09, 0.11))
	_add_label("ÁTRIO DE DISTRIBUIÇÃO", Vector3(0, 2.35, 1.82))
	_add_label("ARQUIVO", Vector3(-11, 2.35, 1.82))
	_add_label("LABORATÓRIO", Vector3(11, 2.35, 1.82))


func _build_lighting() -> void:
	_add_light("AtriumLightA", Vector3(-6, 2.8, 9), 3.2, 10.0, Color(0.72, 0.84, 1.0))
	_add_light("AtriumLightB", Vector3(6, 2.8, 9), 3.2, 10.0, Color(0.72, 0.84, 1.0))
	_add_light("ArchiveLight", Vector3(-11, 2.7, -3.5), 3.0, 10.0, Color(1.0, 0.68, 0.4))
	_add_light("LabLight", Vector3(11, 2.7, -3.5), 3.0, 10.0, Color(0.42, 0.76, 1.0))
	_add_light("RearLight", Vector3(0, 2.7, -12), 2.1, 8.0, Color(0.5, 0.62, 0.85))


func _create_box(node_name: String, position_value: Vector3, size: Vector3, color: Color, collidable := true) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "%sMesh" % node_name
	mesh_instance.position = position_value
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = _material(color)
	mesh_instance.mesh = mesh
	add_child(mesh_instance)
	if not collidable:
		return
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position_value
	body.collision_layer = 1
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)


func _material(color: Color) -> StandardMaterial3D:
	var key := color.to_html()
	if _materials.has(key):
		return _materials[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.76
	_materials[key] = material
	return material


func _add_light(node_name: String, position_value: Vector3, energy: float, light_range: float, color: Color) -> void:
	var light := OmniLight3D.new()
	light.name = node_name
	light.position = position_value
	light.light_color = color
	light.light_energy = energy
	light.omni_range = light_range
	light.shadow_enabled = true
	light.add_to_group("house_lights")
	add_child(light)


func _add_label(text_value: String, position_value: Vector3) -> void:
	var label := Label3D.new()
	label.text = text_value
	label.position = position_value
	label.rotation_degrees.y = 180.0
	label.font_size = 48
	label.outline_size = 8
	label.modulate = Color(0.66, 0.78, 0.88)
	add_child(label)

