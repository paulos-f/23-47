extends Node

signal minute_changed(hour: int, minute: int, display_time: String)
signal time_reached(hour: int, minute: int)
signal loop_finished

const MINUTES_PER_DAY := 24 * 60
const LOOP_START_MINUTE := 23 * 60 + 47
const LOOP_END_MINUTE := 24 * 60

@export_range(0.1, 60.0, 0.1) var seconds_per_game_minute := 5.0
@export_range(0.0, 20.0, 0.1) var time_scale := 1.0

var current_total_minutes := LOOP_START_MINUTE
var loop_start_minute := LOOP_START_MINUTE
var loop_end_minute := LOOP_END_MINUTE
var _second_accumulator := 0.0
var _running := false


func _process(delta: float) -> void:
	if not _running or time_scale <= 0.0:
		return

	_second_accumulator += delta * time_scale
	while _second_accumulator >= seconds_per_game_minute and _running:
		_second_accumulator -= seconds_per_game_minute
		_advance_minute()


func start_loop() -> void:
	current_total_minutes = loop_start_minute
	_second_accumulator = 0.0
	_running = true
	_emit_current_time()


func pause() -> void:
	_running = false


func resume() -> void:
	_running = true


func configure_loop(start_hour: int, start_minute: int, end_hour: int, end_minute: int, seconds_per_minute: float) -> void:
	loop_start_minute = start_hour * 60 + start_minute
	loop_end_minute = end_hour * 60 + end_minute
	if loop_end_minute <= loop_start_minute:
		loop_end_minute += MINUTES_PER_DAY
	seconds_per_game_minute = maxf(seconds_per_minute, 0.1)


func get_display_time() -> String:
	var normalized := current_total_minutes % MINUTES_PER_DAY
	return "%02d:%02d" % [normalized / 60, normalized % 60]


func get_hour() -> int:
	return (current_total_minutes % MINUTES_PER_DAY) / 60


func get_minute() -> int:
	return current_total_minutes % 60


func _advance_minute() -> void:
	current_total_minutes += 1
	_emit_current_time()
	if current_total_minutes >= loop_end_minute:
		_running = false
		loop_finished.emit()


func _emit_current_time() -> void:
	var hour := get_hour()
	var minute := get_minute()
	minute_changed.emit(hour, minute, get_display_time())
	time_reached.emit(hour, minute)
