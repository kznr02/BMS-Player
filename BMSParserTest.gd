extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var bms = BMSParser.new()
	bms.parse_bms("assets/elegante/02_hyper.bme")
	var notes = bms.parse_notes()
	for j in notes:
		print(j)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
