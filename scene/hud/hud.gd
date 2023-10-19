extends CanvasLayer

var bms_path: String = ""

signal game_start

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	game_start.emit()
	$Button.hide()
	pass # Replace with function body.
	
func get_bms_path() -> String:
	return bms_path
