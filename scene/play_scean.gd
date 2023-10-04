extends Node

const key_width = 60.0
const lane_width = 60.0
const start_point = 0 + key_width / 2
const gap = 64.0
const BPM = 133.0

@export var note_blue: PackedScene
@export var note_white: PackedScene
@export var note_red: PackedScene
@export var note_bgm: PackedScene
@export var bar_line: PackedScene
@export var alive_time = 600.0

var bar_length
var step 
var bms_parser
var wav_map = {}
var wav_map_4 = {}
var wav_map_16 = {}
	
var notes_list
var wav_file_list

func _init():
	bms_parser = BMSParser.new()
	
	bar_length = (60 / BPM * 4) * 1000   # bartime (ms)
	step = 576 / alive_time	* 10			 # px per ms
	pass

func _ready():
	bms_parser.parse_bms("assets/elegante/02_hyper.bme")
	var notes = bms_parser.get_notes()
	
	# Get BGM Obj
	var bgm_files = bms_parser.get_bgm_file()
	for bf in bgm_files:
		var file_json = JSON.parse_string(bf)
		wav_map[file_json[0]] = file_json[1]
		
	for i in range(0, 65):
		var line = bar_line.instantiate()
		line.points = PackedVector2Array([Vector2(0, 576 - i * bar_length * step / 10), \
						Vector2(512, 576 - i * bar_length * step / 10)])
		line.set_bar_id(i)
		line.default_color = Color.WHITE
		line.width = 5
		line.add_to_group("bar_line")
		add_child(line)
		
	for n in notes:
		var note_json = JSON.parse_string(n)
		var track = note_json["offset"]["track"]
		var numerator = note_json["offset"]["numerator"]
		var denominator = note_json["offset"]["denominator"]
		var y = 576 - (track * bar_length + bar_length / denominator * numerator) * step / 10
		var key = note_json["key"]
		var id = note_json["obj"]
		var note
		if note_json["kind"] == "Invisible":
			continue
		match key:
			"Key1":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap, y)
			"Key2":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 2, y)	
			"Key3":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 3, y)	
			"Key4":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 4, y)
			"Key5":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 5, y)
			"Key6":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 6, y)
			"Key7":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 7, y)
			"Scratch":
				note = note_red.instantiate()
				note.position = Vector2(start_point, y)
		if note != null:
			note.set_obj_id(id)
			var stream = load("assets/elegante/" + wav_map[id].get_basename() + ".ogg")
			stream.loop = false
			note.set_key_sound(stream)
			var w = note.texture.get_width()
			var scale = lane_width / w
			note.scale = Vector2(scale, scale)
			note.add_to_group("notes")
			add_child(note)
	
	var bgm_objs = bms_parser.get_bgm()
	for b in bgm_objs:
		var bgm_json = JSON.parse_string(b)
		var track = bgm_json[0]["track"]
		var numerator = bgm_json[0]["numerator"]
		var denominator = bgm_json[0]["denominator"]
		var y = 576 - (track * bar_length + bar_length / denominator * numerator) * step / 10
		for id in bgm_json[1]:
			var bgm_obj = note_bgm.instantiate()
			bgm_obj.set_obj_id(id)
			var stream = load("assets/elegante/" + wav_map[id].get_basename() + ".ogg")
			stream.loop = false
			bgm_obj.set_key_sound(stream)
			bgm_obj.position = Vector2(start_point, y)
			bgm_obj.add_to_group("bgm_notes")
			add_child(bgm_obj)
			
	print("load success")
	$Timer.wait_time = 0.01
	$Timer.start()
	
func _on_timer_timeout():
	get_tree().call_group("bgm_notes", "is_hit", 576.0)
	get_tree().call_group("bar_line", "is_hit", 576.0)
	get_tree().call_group("notes", "is_hit", 576.0)
	get_tree().call_group("bar_line", "move", step)
	get_tree().call_group("bgm_notes", "move", step)
	get_tree().call_group("notes", "move", step)
	
	pass
	
	
func _process(delta):
	if Input.is_action_just_pressed("Z"):
		pass
	
	
	pass # Replace with function body.
