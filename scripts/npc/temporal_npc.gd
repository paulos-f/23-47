class_name TemporalNPC
extends CharacterBody3D

@export_range(0.1, 8.0, 0.1) var movement_speed := 2.0
@export var routine_points_group: StringName = &"npc_routine_points"
@export var key_drop_point_group: StringName = &"key_drop_point"
@export var carried_key_scene: PackedScene

@onready var visual: Node3D = $Visual
@onready var left_arm: Node3D = $Visual/LeftArm
@onready var right_arm: Node3D = $Visual/RightArm
@onready var left_leg: Node3D = $Visual/LeftLeg
@onready var right_leg: Node3D = $Visual/RightLeg

var has_key := true
var _target: Node3D
var _activity := "sentado na sala"
var _walk_time := 0.0


func _ready() -> void:
	TimeManager.minute_changed.connect(_on_minute_changed)
	call_deferred("_sync_to_current_time")


func _physics_process(delta: float) -> void:
	if _target == null:
		velocity = Vector3.ZERO
		_animate_character(delta, false)
		return
	var offset := _target.global_position - global_position
	offset.y = 0.0
	if offset.length() < 0.15:
		velocity = Vector3.ZERO
		_animate_character(delta, false)
		return
	var direction := offset.normalized()
	velocity = direction * movement_speed
	look_at(global_position + direction, Vector3.UP)
	move_and_slide()
	_animate_character(delta, true)


func _animate_character(delta: float, walking: bool) -> void:
	if walking:
		_walk_time += delta * 7.5
	var target_swing := sin(_walk_time) * 0.62 if walking else 0.0
	left_arm.rotation.x = lerp(left_arm.rotation.x, target_swing, delta * 9.0)
	right_arm.rotation.x = lerp(right_arm.rotation.x, -target_swing, delta * 9.0)
	left_leg.rotation.x = lerp(left_leg.rotation.x, -target_swing * 0.72, delta * 9.0)
	right_leg.rotation.x = lerp(right_leg.rotation.x, target_swing * 0.72, delta * 9.0)
	visual.position.y = sin(_walk_time * 2.0) * 0.018 if walking else sin(Time.get_ticks_msec() * 0.0015) * 0.008


func get_interaction_prompt(_player: Node) -> String:
	return "[E] Conversar"


func interact(_player: Node) -> String:
	if TimeManager.current_total_minutes < 23 * 60 + 51:
		return "“Não consigo parar agora.” Ele parece proteger algo no bolso."
	if has_key:
		return "“Você está procurando alguma coisa?”"
	return "Ele olha repetidamente para a mesa da cozinha."


func place_key_on_table() -> void:
	if not has_key or carried_key_scene == null:
		return
	var drop_point := get_tree().get_first_node_in_group(key_drop_point_group) as Node3D
	if drop_point == null:
		push_warning("Ponto de depósito da chave não encontrado.")
		return
	var key := carried_key_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(key)
	key.global_transform = drop_point.global_transform
	has_key = false
	GameManager.show_message("O morador deixa uma chave sobre a mesa.", 2.8)


func take_key_from_table() -> void:
	for candidate in get_tree().get_nodes_in_group("collectible_key"):
		if candidate.key_id == &"office_key" and not candidate.collected:
			candidate.queue_free()
			has_key = true
			GameManager.show_message("O morador recolhe a chave da mesa.", 2.8)
			return
	has_key = false


func _sync_to_current_time() -> void:
	_on_minute_changed(TimeManager.get_hour(), TimeManager.get_minute(), TimeManager.get_display_time())


func _on_minute_changed(hour: int, minute: int, _display_time: String) -> void:
	var now := hour * 60 + minute
	var selected: NPCRoutinePoint
	var selected_time := -1
	for point in get_tree().get_nodes_in_group(routine_points_group):
		if point is NPCRoutinePoint:
			var point_time: int = point.total_minutes()
			if point_time <= now and point_time > selected_time:
				selected = point
				selected_time = point_time
	if selected != null:
		_target = selected
		_activity = selected.activity
