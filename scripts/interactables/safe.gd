class_name KnowledgeSafe
extends StaticBody3D

@export var required_knowledge: StringName = &"safe_code_discovered"
@export var code := "1987"
@export var reward_scene: PackedScene

@onready var lid: Node3D = $Lid

var opened := false


func get_interaction_prompt(_player: Node) -> String:
	if opened:
		return "[E] Examinar cofre aberto"
	if KnowledgeManager.knows(required_knowledge):
		return "[E] Digitar %s" % code
	return "[E] Examinar cofre"


func interact(_player: Node) -> String:
	if opened:
		return "No interior há o encaixe onde o fusível estava guardado."
	if not KnowledgeManager.knows(required_knowledge):
		return "Um teclado de quatro dígitos. Você ainda não sabe a senha."
	opened = true
	KnowledgeManager.learn(&"safe_opened", true)
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(lid, "rotation:x", deg_to_rad(-105.0), 0.8)
	_spawn_reward()
	return "1987. O cofre se abre. Dentro dele há um fusível antigo."


func _spawn_reward() -> void:
	if reward_scene == null:
		return
	var reward := reward_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(reward)
	reward.global_transform = $RewardSpawn.global_transform
