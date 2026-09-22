class_name PrototypeHouse
extends Node3D

const WALL_HEIGHT := 2.8

var _materials: Dictionary = {}


func _ready() -> void:
	_build_environment()
	_build_shell()
	_build_furniture()
	_build_lighting()


func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	world_environment.name = "NightEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.012, 0.016, 0.032)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.19, 0.22, 0.3)
	environment.ambient_light_energy = 0.72
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 1.22
	world_environment.environment = environment
	add_child(world_environment)

	var moon := DirectionalLight3D.new()
	moon.name = "Moonlight"
	moon.rotation_degrees = Vector3(-58.0, -32.0, 0.0)
	moon.light_color = Color(0.28, 0.38, 0.62)
	moon.light_energy = 0.62
	moon.shadow_enabled = true
	add_child(moon)


func _build_shell() -> void:
	_create_box("Floor", Vector3(0, -0.12, 0), Vector3(24, 0.24, 18), Color(0.17, 0.13, 0.1))
	_create_box("Ceiling", Vector3(0, WALL_HEIGHT + 0.12, 0), Vector3(24, 0.24, 18), Color(0.055, 0.06, 0.07), false)

	var wall_color := Color(0.22, 0.2, 0.17)
	_create_box("NorthWall", Vector3(0, WALL_HEIGHT / 2.0, -9), Vector3(24, WALL_HEIGHT, 0.25), wall_color)
	_create_box("SouthWall", Vector3(0, WALL_HEIGHT / 2.0, 9), Vector3(24, WALL_HEIGHT, 0.25), wall_color)
	_create_box("WestWall", Vector3(-12, WALL_HEIGHT / 2.0, 0), Vector3(0.25, WALL_HEIGHT, 18), wall_color)
	_create_box("EastWall", Vector3(12, WALL_HEIGHT / 2.0, 0), Vector3(0.25, WALL_HEIGHT, 18), wall_color)

	# Parede central: uma abertura para a cozinha e outra para o escritório.
	_create_box("CenterWallA", Vector3(-8, WALL_HEIGHT / 2.0, 0), Vector3(8, WALL_HEIGHT, 0.22), wall_color)
	_create_box("CenterWallB", Vector3(0.5, WALL_HEIGHT / 2.0, 0), Vector3(5, WALL_HEIGHT, 0.22), wall_color)
	_create_box("CenterWallC", Vector3(8.4, WALL_HEIGHT / 2.0, 0), Vector3(7.2, WALL_HEIGHT, 0.22), wall_color)
	_create_box("OfficeDivider", Vector3(1.0, WALL_HEIGHT / 2.0, -4.5), Vector3(0.22, WALL_HEIGHT, 9), wall_color)
	# A sala de arquivo forma o segundo bloqueio da progressão.
	_create_box("ArchiveWallA", Vector3(3.1, WALL_HEIGHT / 2.0, -5.7), Vector3(4.2, WALL_HEIGHT, 0.22), wall_color)
	_create_box("ArchiveWallB", Vector3(9.5, WALL_HEIGHT / 2.0, -5.7), Vector3(5.0, WALL_HEIGHT, 0.22), wall_color)


func _build_furniture() -> void:
	var wood := Color(0.22, 0.105, 0.045)
	_create_box("KitchenTableTop", Vector3(-4.4, 0.86, -3.0), Vector3(2.8, 0.14, 1.35), wood)
	for corner in [Vector3(-5.55, 0.42, -3.5), Vector3(-3.25, 0.42, -3.5), Vector3(-5.55, 0.42, -2.5), Vector3(-3.25, 0.42, -2.5)]:
		_create_box("TableLeg", corner, Vector3(0.15, 0.84, 0.15), wood)

	_create_box("OfficeDesk", Vector3(6.3, 0.68, -4.5), Vector3(2.8, 1.36, 0.9), Color(0.15, 0.065, 0.03))
	_create_box("Sofa", Vector3(-1.0, 0.48, 4.4), Vector3(3.1, 0.95, 1.05), Color(0.12, 0.18, 0.2))
	_create_box("LowTable", Vector3(2.0, 0.34, 4.0), Vector3(1.8, 0.68, 1.0), wood)
	_create_box("HallCabinet", Vector3(-1.3, 0.7, -5.8), Vector3(1.4, 1.4, 0.55), Color(0.12, 0.07, 0.04))
	_create_box("ArchiveTable", Vector3(7.4, 0.66, -7.45), Vector3(2.6, 1.32, 0.85), Color(0.115, 0.052, 0.028))
	_create_box("ArchiveShelf", Vector3(10.7, 1.05, -7.9), Vector3(0.65, 2.1, 1.5), Color(0.08, 0.09, 0.085))


func _build_lighting() -> void:
	_add_warm_light("LivingLight", Vector3(0, 2.35, 4.2), 3.2, 9.5)
	_add_warm_light("KitchenLight", Vector3(-4.5, 2.35, -3.2), 2.8, 8.0)
	_add_warm_light("OfficeLight", Vector3(6.5, 2.35, -3.2), 2.65, 7.5)
	_add_warm_light("HallLight", Vector3(-0.8, 2.25, -4.8), 2.1, 6.5)
	_add_warm_light("ArchiveLight", Vector3(7.4, 2.25, -7.4), 2.0, 6.0)
	# Preenchimentos suaves não desligam: preservam leitura sem remover a atmosfera.
	_add_fill_light("EntryFill", Vector3(7.8, 1.8, 5.8), 0.7, 7.0)
	_add_fill_light("KitchenCornerFill", Vector3(-9.0, 1.7, -6.5), 0.62, 7.0)
	_add_fill_light("CorridorFill", Vector3(-0.8, 1.6, -7.5), 0.55, 5.5)


func _create_box(node_name: String, box_position: Vector3, size: Vector3, color: Color, collidable := true) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "%sMesh" % node_name
	mesh_instance.position = box_position
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = _get_material(color)
	mesh_instance.mesh = mesh
	add_child(mesh_instance)

	if not collidable:
		return
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = box_position
	body.collision_layer = 1
	body.collision_mask = 0
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)


func _get_material(color: Color) -> StandardMaterial3D:
	var key := color.to_html()
	if _materials.has(key):
		return _materials[key]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.82
	_materials[key] = material
	return material


func _add_warm_light(node_name: String, light_position: Vector3, energy: float, light_range: float) -> void:
	var light := OmniLight3D.new()
	light.name = node_name
	light.position = light_position
	light.light_color = Color(1.0, 0.63, 0.34)
	light.light_energy = energy
	light.omni_range = light_range
	light.shadow_enabled = true
	light.add_to_group("house_lights")
	add_child(light)
	_add_light_fixture(light_position)


func _add_fill_light(node_name: String, light_position: Vector3, energy: float, light_range: float) -> void:
	var light := OmniLight3D.new()
	light.name = node_name
	light.position = light_position
	light.light_color = Color(0.34, 0.44, 0.68)
	light.light_energy = energy
	light.omni_range = light_range
	light.shadow_enabled = false
	add_child(light)


func _add_light_fixture(fixture_position: Vector3) -> void:
	var fixture := MeshInstance3D.new()
	fixture.position = fixture_position
	var mesh := SphereMesh.new()
	mesh.radius = 0.13
	mesh.height = 0.16
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.72, 0.38)
	material.emission_enabled = true
	material.emission = Color(1.0, 0.42, 0.12)
	material.emission_energy_multiplier = 2.2
	mesh.material = material
	fixture.mesh = mesh
	add_child(fixture)
