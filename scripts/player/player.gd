class_name FirstPersonPlayer
extends CharacterBody3D

signal interaction_prompt_changed(text: String)
signal message_requested(text: String, duration: float)

@export_range(0.1, 20.0, 0.1) var walk_speed := 4.0
@export_range(0.1, 30.0, 0.1) var sprint_speed := 7.0
@export_range(0.1, 15.0, 0.1) var jump_velocity := 4.8
@export_range(0.0001, 0.02, 0.0001) var mouse_sensitivity := 0.0022

@onready var camera: Camera3D = $Camera3D
@onready var inventory: PlayerInventory = $Inventory
@onready var interactor: PlayerInteractor = $Interactor

var controls_enabled := true
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)


func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interactor.prompt_changed.connect(interaction_prompt_changed.emit)
	interactor.interaction_finished.connect(_on_interaction_finished)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_mouse"):
		Input.mouse_mode = (
			Input.MOUSE_MODE_VISIBLE
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			else Input.MOUSE_MODE_CAPTURED
		)
		return

	if not controls_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotation.x = clamp(
			camera.rotation.x - event.relative.y * mouse_sensitivity,
			-deg_to_rad(88.0),
			deg_to_rad(88.0)
		)
	if event.is_action_pressed("interact"):
		interactor.try_interact()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta

	if not controls_enabled:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed)
		move_and_slide()
		return

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	var target_speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	if direction != Vector3.ZERO:
		velocity.x = direction.x * target_speed
		velocity.z = direction.z * target_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, target_speed * delta * 8.0)
		velocity.z = move_toward(velocity.z, 0.0, target_speed * delta * 8.0)
	move_and_slide()


func set_controls_enabled(enabled: bool) -> void:
	controls_enabled = enabled
	if not enabled:
		interaction_prompt_changed.emit("")


func _on_interaction_finished(message: String) -> void:
	message_requested.emit(message, 2.5)

