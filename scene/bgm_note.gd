extends Sprite2D

var id:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_obj_id(id: int):
	id = id
	pass

func set_key_sound(stream):
	$KeySound.stream = stream
	pass
	
func play_key_sound():
	$KeySound.play()
	
func move(y):
	position.y += y
	
func is_hit(y):
	if position.y > y:
		play_key_sound()
		self.remove_from_group("bgm_notes")


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.
