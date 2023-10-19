extends Node2D

@export var AudioContainer: PackedScene

func load_audio(files: Array, path: String):
	for f in files:
		var inf = JSON.parse_string(f)
		var id = inf[0]
		var file_name = inf[1].get_basename() 
		var tmp_audio_container = AudioContainer.instantiate()
		var tmp_stream = load(path + file_name+ ".ogg")
		if tmp_stream == null:
			tmp_stream = load(path + file_name + ".wav")
			if tmp_stream == null:
				printerr("Can't load audio of {}".format([path+file_name], "{}"))
		tmp_audio_container.set_rsc_id(id)
		tmp_audio_container.set_stream_and_disable_loop(tmp_stream)
		tmp_audio_container.add_to_group("BGM")
		self.add_child(tmp_audio_container)

var sequence = {}
func make_seq(seq_arr: Array, bpm: float):
	var bps = 60 / bpm
	for seq in seq_arr:
		var json = JSON.parse_string(seq)
		var track = json[0]["track"]
		var numerator = json[0]["numerator"]
		var denominator = json[0]["denominator"]
		var ids = json[1]
		var pos = int((track + 1 / denominator * numerator) * bps * 4 * 1000)
		sequence[pos] = ids
		pass

var time = 0
func start_play():
	$BGMTimer.start(0.01)
	pass

func get_seq() -> Dictionary:
	return sequence

func _physics_process(delta):
	for time_stamp in sequence:
		if time_stamp < time:
			for id in sequence[time_stamp]:
				get_tree().call_group("BGM", "call_deferred", "play_audio", id)
			sequence.erase(time_stamp)
		pass

func play_audio(id):
	get_tree().call_group("BGM", "call_deferred", "play_audio", id)

func _on_bgm_timer_timeout():
	time += 10
	pass # Replace with function body.
