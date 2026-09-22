class_name AmbientMusic
extends AudioStreamPlayer

@export_range(-40.0, 0.0, 1.0) var music_volume_db := -15.0

const MIX_RATE := 16000
const LOOP_SECONDS := 16.0
const CHORDS := [
	[65.41, 77.78, 98.0],
	[58.27, 73.42, 87.31],
	[55.0, 65.41, 82.41],
	[65.41, 77.78, 98.0],
]


func _ready() -> void:
	add_to_group("ambient_music")
	stream = _build_ambient_loop()
	volume_db = music_volume_db
	play()


func _build_ambient_loop() -> AudioStreamWAV:
	var frame_count := int(MIX_RATE * LOOP_SECONDS)
	var pcm := PackedByteArray()
	pcm.resize(frame_count * 4)
	for frame in range(frame_count):
		var sample_time := float(frame) / float(MIX_RATE)
		var chord_index := int(sample_time / 4.0) % CHORDS.size()
		var chord: Array = CHORDS[chord_index]
		var breath := 0.74 + sin(sample_time * 0.55) * 0.15
		var edge_fade: float = minf(1.0, minf(sample_time / 0.35, (LOOP_SECONDS - sample_time) / 0.35))
		var sample := 0.0
		for index in range(chord.size()):
			var frequency: float = chord[index]
			sample += sin(TAU * frequency * sample_time + index * 0.7) * (0.16 / float(index + 1))
		sample += sin(TAU * (float(chord[0]) * 0.5) * sample_time) * 0.1
		var shimmer := sin(TAU * (float(chord[2]) * 2.0) * sample_time) * 0.025
		var left: float = clampf((sample * breath + shimmer) * edge_fade, -1.0, 1.0)
		var right: float = clampf((sample * breath - shimmer) * edge_fade, -1.0, 1.0)
		pcm.encode_s16(frame * 4, int(left * 32767.0))
		pcm.encode_s16(frame * 4 + 2, int(right * 32767.0))

	var wave := AudioStreamWAV.new()
	wave.format = AudioStreamWAV.FORMAT_16_BITS
	wave.mix_rate = MIX_RATE
	wave.stereo = true
	wave.data = pcm
	wave.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wave.loop_begin = 0
	wave.loop_end = frame_count
	return wave


func _exit_tree() -> void:
	shutdown()


func shutdown() -> void:
	stop()
	stream = null
