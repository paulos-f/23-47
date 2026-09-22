class_name NPCRoutinePoint
extends Marker3D

@export_range(0, 23, 1) var trigger_hour := 23
@export_range(0, 59, 1) var trigger_minute := 47
@export var activity := "aguarda"


func total_minutes() -> int:
	return trigger_hour * 60 + trigger_minute

