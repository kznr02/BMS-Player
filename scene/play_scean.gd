extends Node

const key_width = 60.0
const key_height = 40
const lane_width = 60.0
const start_point_x = 0 + key_width / 2.0
const start_point_y = 0 - key_height / 2.0
const gap = 64.0
const BPM = 133.0

@export var note_blue: PackedScene
@export var note_white: PackedScene
@export var note_red: PackedScene
@export var note_bgm: PackedScene
@export var bar_line: PackedScene
@export var alive_time = 600.0
@export var bms_dir_path = "assets/elegante/"
@export var bms_file_path = "03_another.bme"
@export var judge_line_y_pos = 0

var bar_length
var step 
var bms_parser
var mode = 1

var note_list = []

func start_play():
	bms_parser.parse_bms(bms_dir_path + bms_file_path)
	
	$BGMSequencer.load_audio(bms_parser.get_bgm_file(), bms_dir_path)
	$BGMSequencer.make_seq(bms_parser.get_bgm(), BPM)
	var notes = bms_parser.get_notes()

	for i in range(0, 65):
		var line = bar_line.instantiate()
		line.points = PackedVector2Array([Vector2(0, 576 - i * bar_length * step), \
						Vector2(512, 576 - i * bar_length * step)])
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
		var y = 576 - (track * bar_length + bar_length / denominator * numerator) * step
		var key = note_json["key"]
		var id = note_json["obj"]
		var note
		match key:
			"Key1":
				note = note_white.instantiate()
				note.position = Vector2(start_point_x + gap, y)
				note.set_lane(1)
				note.add_to_group("key1")
			"Key2":
				note = note_blue.instantiate()
				note.position = Vector2(start_point_x + gap * 2, y)	
				note.set_lane(2)
				note.add_to_group("key2")
			"Key3":
				note = note_white.instantiate()
				note.position = Vector2(start_point_x + gap * 3, y)	
				note.set_lane(3)
				note.add_to_group("key3")
			"Key4":
				note = note_blue.instantiate()
				note.position = Vector2(start_point_x + gap * 4, y)
				note.set_lane(4)
				note.add_to_group("key4")
			"Key5":
				note = note_white.instantiate()
				note.position = Vector2(start_point_x + gap * 5, y)
				note.set_lane(5)
				note.add_to_group("key5")
			"Key6":
				note = note_blue.instantiate()
				note.position = Vector2(start_point_x + gap * 6, y)
				note.set_lane(6)
				note.add_to_group("key6")
			"Key7":
				note = note_white.instantiate()
				note.position = Vector2(start_point_x + gap * 7, y)
				note.set_lane(7)
				note.add_to_group("key7")
			"Scratch":
				note = note_red.instantiate()
				note.position = Vector2(start_point_x, y)
				note.set_lane(0)
				note.add_to_group("scratch")
		if note != null:
			if note_json["kind"] == "Invisible":
				note.visible = false
			note.set_obj_id(id)
			var w = note.texture.get_width()
			var scale = lane_width / w
			note.scale = Vector2(scale, scale)
			add_child(note)
			
	note_list.push_back(get_tree().get_nodes_in_group("scratch")) 
	for i in range(1, 8):
		note_list.push_back(get_tree().get_nodes_in_group("key{}".format([i], "{}"))) 
	
	$BGMSequencer.start_play()
	print("load success")

func _init():
	bms_parser = BMSParser.new()
	bar_length = (60 / BPM * 4) * 1000   # bartime (ms)
	step = 576 / alive_time			 # px per ms(*10)
	pass

func _ready():
	pass

func _process(delta):
	for i in note_list:
		if !i.is_empty():
			if i.front().position.y > 576:
				var node = i.pop_front()
				$BGMSequencer.play_audio(node.get_obj_id())
				node.remove_from_group(node.get_groups()[0])
				node.queue_free()
	get_tree().call_group("bgm_notes", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key1", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key2", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key3", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key4", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key5", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key6", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("key7", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("scratch", "call_deferred", "move", step * delta * 1000)
	get_tree().call_group("bar_line", "call_deferred", "move", step * delta * 1000)

func _physics_process(delta):
	pass

func _input(event):
	pass
