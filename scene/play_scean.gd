extends Node

@export var note_blue: PackedScene
@export var note_white: PackedScene
@export var note_red: PackedScene
@export var length_per_track = 1200
	
var bms_parser


const key_width = 60.0
const lane_width = 60.0
const start_point = 0 + key_width / 2
const gap = 64.0
const BPM = 133.0

enum NoteKind {
	Visible,
	Invisible,
	Long,
	Landmine,
}

enum Key {
	Key1,
	Key2,
	Key3,
	Key4,
	Key5,
	Key6,
	Key7,
	Scratch,
	FreeZone,
}

func _init():
	bms_parser = BMSParser.new()
	
	pass

func _ready():
	bms_parser.parse_bms("assets/elegante/02_hyper.bme")
	var notes = bms_parser.parse_notes()
		
	for n in notes:
		# print(n)
		var json = JSON.parse_string(n)
		var track = json["offset"]["track"]
		var numerator = json["offset"]["numerator"]
		var denominator = json["offset"]["denominator"]
		var y = 0 - (length_per_track * (track - 1) + length_per_track / denominator * numerator)
		var key = json["key"]
		var note
		if json["kind"] == "Invisible":
			break
		
		match key:
			"Key1":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap, y)
			"Key2":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 2, y)	
			"Key3":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 3, y)	
			"Key4":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 4, y)
			"Key5":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 5, y)
			"Key6":
				note = note_white.instantiate()
				note.position = Vector2(start_point + gap * 6, y)
			"Key7":
				note = note_blue.instantiate()
				note.position = Vector2(start_point + gap * 7, y)
			"Scratch":
				note = note_red.instantiate()
				note.position = Vector2(start_point, y)
				
		if note != null:
			var w = note.texture.get_width()
			var scale = lane_width / w
			note.scale = Vector2(scale, scale)
			note.add_to_group("notes")
			add_child(note)
	notes_list = get_tree().get_nodes_in_group("notes")
	$Timer.wait_time = 1 / BPM 
	$Timer.start()
	
var notes_list

func _on_timer_timeout():
	if notes_list != null:
		for n in notes_list:
			n.position.y += 5
	pass # Replace with function body.
